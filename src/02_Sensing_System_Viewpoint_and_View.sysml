// https://github.com/Systems-Modeling/SysML-v2-Release 2021-08

import Views::*; // import library package, not internal Views package!
package 'Sensing System Viewpoints and Views'
{
    import 'Sensing System Stakeholder'::*;

    viewpoint 'customer viewpoint' {
        frame 'requirement traceability';
        frame 'requirement refinement';

        require constraint {
            doc /* A system structure show the hierarchical part decomposition of a system from customer requirement. */
        }
    }
    view def 'Customer View Def' {
        satisfy 'customer viewpoint';
    }
    view 'customer view': 'Customer View Def' {
        expose 'Sensing System Base Architecture'::**;
// @ToDo Temporarily commented out due to eclipse's heavy process load
//        expose 'Sensing System Requirements'::**;
//        expose 'Sensing System Context'::**;
//        expose 'Sensing System Use Case'::**;
//        expose 'Sensing System Use Case Activity'::**;
//        expose 'Sensing System Processes'::**;
//        expose 'Sensing System Domain Knowledge'::**;
//        expose 'Sensing System Logical Architecture'::**;
//        expose 'Sensing System Logical Architecture State Machine'::**;
//        expose 'Sensing System Logical Architecture Sequence'::**;
        render asTreeDiagram;
    }

    viewpoint 'software engineer viewpoint' {
        frame 'requirement refinement';
        frame 'requirement and architecture definition';
        frame 'feasible system requirement and architecture';

        require constraint {
            doc /* A system structure show the hierarchical part decomposition of a system for software domain engineer. */
        }
    }
    view def 'Software Engineer View Def' {
        satisfy 'software engineer viewpoint';
    }
    view 'software engineer view': 'Software Engineer View Def' {
        expose 'Sensing System Requirements'::**;
// @ToDo Temporarily commented out due to eclipse's heavy process load
//        expose 'Sensing System Domain Knowledge'::**;
//        expose 'Sensing System Logical Architecture'::**;
//        expose 'Sensing System Logical Architecture State Machine'::**;
//        expose 'Sensing System Logical Architecture Sequence'::**;
        render asTreeDiagram;
    }
}
