# SPDX-License-Identifier: Apache-2.0
# Copyright 2021 Kenji Miyake

import argparse
import json
import re
from collections import defaultdict
from logging import StreamHandler, _nameToLevel, basicConfig, getLogger
from pathlib import Path

import nbformat
from nbclient import NotebookClient

logger = getLogger(__name__)
logger.setLevel("DEBUG")


def create_empty_notebook():
    return {
        "cells": [],
        "metadata": {
            "kernelspec": {
                "display_name": "SysML",
                "language": "sysml",
                "name": "sysml",
            },
            "language_info": {
                "codemirror_mode": "sysml",
                "file_extension": ".sysml",
                "mimetype": "text/x-sysml",
                "name": "SysML",
                "pygments_lexer": "java",
                "version": "1.0.0",
            },
        },
        "nbformat": 4,
        "nbformat_minor": 5,
    }


def create_markdown_cell(source: str):
    return {
        "cell_type": "markdown",
        "metadata": {},
        "source": source,
    }


def create_code_cell(source: str):
    return {
        "cell_type": "code",
        "execution_count": 0,
        "metadata": {},
        "outputs": [],
        "source": source,
    }


def create_file_cells(file_path: Path):
    return [
        create_markdown_cell(f"## {str(file_path)}"),
        create_code_cell(file_path.read_text()),
    ]


def analyze_dependencies(files: list[Path]):
    define_package_map = {}
    import_package_map = defaultdict(list)

    for file in files:
        with open(file, "r") as f:
            for line in f.readlines():
                if m := re.match(r"^\s*package\s+([a-zA-Z0-9\s']+)", line):
                    define_package_name = m.groups()[0].replace("'", "").strip()
                    define_package_map[define_package_name] = file

                if m := re.match(r"^\s*import\s+([a-zA-Z0-9\s']+)(::.+)?;", line):
                    import_package_name = m.groups()[0].replace("'", "").strip()
                    import_package_map[file].append(import_package_name)

    dependency_map = defaultdict(list)

    for file in files:
        for import_package in import_package_map[file]:
            # Ignore standard libraries
            if not define_package_map.get(import_package):
                continue

            dependency_file = define_package_map[import_package]
            if file == dependency_file:
                continue

            logger.debug(f"{file} depends on {dependency_file}")
            dependency_map[file].append(dependency_file)

    ordered_files = []
    added = set()

    def is_all_depends_ok(file):
        for dependency in dependency_map[file]:
            if not dependency in added:
                return False
        return True

    def is_all_depends_added():
        for file in files:
            if not file in added:
                return False
        return True

    while True:
        if is_all_depends_added():
            break

        for file in files:
            if file in added:
                continue
            if is_all_depends_ok(file):
                ordered_files.append(file)
                added.add(file)

    return ordered_files


def sysml2notebook(workspace: Path, command: str):
    notebook = create_empty_notebook()

    ordered_files = analyze_dependencies(list(workspace.glob("**/*.sysml")))

    for file_path in ordered_files:
        notebook["cells"] += create_file_cells(file_path)

    notebook["cells"].append(create_code_cell(command))

    return notebook


def run_notebook(notebook: dict, output_notebook_path: Path):
    with open(output_notebook_path, "w") as f:
        f.write(json.dumps(notebook, indent=2))

    nb = nbformat.read(output_notebook_path, as_version=4)
    client = NotebookClient(nb, timeout=600, kernel_name="sysml")

    client.execute()
    nbformat.write(nb, output_notebook_path)


def notebook2image(output_notebook_path: Path, output_image_path: Path):
    notebook = json.loads(output_notebook_path.read_text())

    image_cell = notebook["cells"][-1]
    image_data = image_cell["outputs"][0]["data"]["image/svg+xml"]

    with open(output_image_path, "w") as f:
        f.writelines(image_data)


def sysml2image(args):
    notebook = sysml2notebook(args.workspace, args.command)
    run_notebook(notebook, args.output_notebook_path)
    notebook2image(args.output_notebook_path, args.output_image_path)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("workspace", type=Path)
    parser.add_argument("--log-level", type=str, default="INFO", choices=_nameToLevel.keys())
    parser.add_argument("-c", "--command", type=str, required=True)
    parser.add_argument("-o", "--output-image-path", type=Path, default="image.svg")
    parser.add_argument("--output-notebook-path", type=Path, default="/tmp/sysml.ipynb")
    args = parser.parse_args()

    handler = StreamHandler()
    handler.setLevel(args.log_level)
    basicConfig(handlers=[handler])

    sysml2image(args)


if __name__ == "__main__":
    main()
