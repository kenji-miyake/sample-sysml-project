// https://github.com/Systems-Modeling/SysML-v2-Release 2021-08
// Graphical features for interactions are not supported yet.
// Features of interactions are limited as of now.

package 'Sensing System Logical Architecture Sequence'
{
	import 'Sensing System Logical Architecture'::*;
	
	occurrence def 'Start the System' {
		ref part :>> arch_cxt;
		// @ToDo Parallel
		message initializeCanInterfaces from arch_cxt.sensing_system_log_arch.mcu to arch_cxt.sensing_system_log_arch.can;
		message determineDefaultData from arch_cxt.sensing_system_log_arch.mcu to arch_cxt.sensing_system_log_arch.mcu;
		// @ToDo Parallel
		message initializeTheSensors from arch_cxt.sensing_system_log_arch.mcu to arch_cxt.sensing_system_log_arch.gs;
	}
	
	occurrence def 'Stop the System' {
		ref part :>> arch_cxt;
		message shutdownTheSensors from arch_cxt.sensing_system_log_arch.mcu to arch_cxt.sensing_system_log_arch.gs;
	}
	
	occurrence def 'Detect the Yaw Moment' {
		ref part :>> arch_cxt;
		message acquireTheYawMotion from arch_cxt.sensing_system_log_arch.mcu to arch_cxt.sensing_system_log_arch.gs;
		// @ToDo if input sensor data is in valid range
		message determineNormalData from arch_cxt.sensing_system_log_arch.mcu to arch_cxt.sensing_system_log_arch.mcu;
		// @ToDo if input sensor data is out of valid range
		message determineTemporaryFailure from arch_cxt.sensing_system_log_arch.mcu to arch_cxt.sensing_system_log_arch.mcu;
	}
	
	occurrence def 'Stop Detecting the Yaw Moment' {
		ref part :>> arch_cxt;
		message determinePermanentFailure from arch_cxt.sensing_system_log_arch.mcu to arch_cxt.sensing_system_log_arch.mcu;
	}
	
	occurrence def 'Transmit the Sensing Data' {
		ref part :>> arch_cxt;
		// @ToDo if yaw moment data status is normal
		message generateNormalFailureData from arch_cxt.sensing_system_log_arch.mcu to arch_cxt.sensing_system_log_arch.mcu;
		// @ToDo if yaw moment data status is temporary failure
		message generateTemporaryFailureData from arch_cxt.sensing_system_log_arch.mcu to arch_cxt.sensing_system_log_arch.mcu;
		// @ToDo if yaw moment data status is permanent failure
		message generatePermanentFailureData from arch_cxt.sensing_system_log_arch.mcu to arch_cxt.sensing_system_log_arch.mcu;
		// @ToDo if yaw moment data status is else
		message generateDefaultData from arch_cxt.sensing_system_log_arch.mcu to arch_cxt.sensing_system_log_arch.mcu;
		message formatData from arch_cxt.sensing_system_log_arch.mcu to arch_cxt.sensing_system_log_arch.mcu;
		message outputCanData from arch_cxt.sensing_system_log_arch.mcu to arch_cxt.sensing_system_log_arch.can;
	}
}
