// https://github.com/Systems-Modeling/SysML-v2-Release 2021-08

package 'Sensing System Use Case Activity'
{
	import 'Sensing System Domain Knowledge'::*;

	// ====================================
	// Definitions of Actions
	// ====================================
	action def StartSystem(out initial: Data_Status);
	action def StopSystem();
	action def DetectYawMoment(in vm: Vehicle_Motion, out temp_fail: Data_Status, out normal: Data_Status, out raw_sen_data: Raw_Sen_Data);
	action def StopDetectingYawMoment(out perm_fail: Data_Status);
	action def TransmitSensingData(in data_status: Data_Status, in raw_sen_data: Raw_Sen_Data, out can_data: CAN_Sen_Data);

	action def Wait100Ms;
	action def InitialCanInterfaces;
	action def InitializeSensors;
	action def DetermineNormalData(in raw_sen_data_in: Raw_Sen_Data, out normal: Data_Status, out raw_sen_data: Raw_Sen_Data);
	action def DetermineDefaultData(out initial: Data_Status);
	action def DeterminePermanentFail(out perm_fail: Data_Status);
	action def DetermineTemporaryFail(out temp_fail: Data_Status, out num_of_fail: Num_Of_Fail);
	action def GenerateNormalData(in raw_sen_data_in: Raw_Sen_Data, out sen_data: Sen_Data);
	action def GenerateDefaultData(out sen_data: Sen_Data);
	action def GeneratePermanentFail(out sen_data: Sen_Data);
	action def GenerateTemporaryFail(out sen_data: Sen_Data);
	action def FormatData(in sen_data_normal: Sen_Data, in sen_data_default: Sen_Data, in sen_data_temp_fail: Sen_Data, in sen_data_perm_fail: Sen_Data, out can_data: CAN_Sen_Data);
	action def OutputCanDat(in can_data_in: CAN_Sen_Data, out can_data: CAN_Sen_Data);
	action def AcquireYawMotion(in vm: Vehicle_Motion, out raw_sen_data: Raw_Sen_Data);
	action def ShutdownSensors;

	item def Power_OFF;
	item def Power_ON;
	item def Initialization_Completed;
	item def Sensor_Failed;

	// ====================================
	// Actions
	// ====================================
	action start_system: StartSystem {
		out item initial;

		first start;
		then fork;
			then initialize_can_interfaces;
			then initialize_sensors;

		action initialize_can_interfaces: InitialCanInterfaces;
		then JoinNode;
		action initialize_sensors: InitializeSensors;
		then fork;
			then JoinNode;
			then merge ContinuousLoop;
			then action determine_default_data: DetermineDefaultData {
				out item initial = start_system.initial;
			}
			then action wait_100ms: Wait100Ms;
			then ContinuousLoop;
		join JoinNode;
		then done;
	}
	action stop_system: StopSystem {
		first start;
		then action shutdown_sensors: ShutdownSensors;
		then done;
	}
	action detect_yaw_moment: DetectYawMoment {
		in item vm;
		out item temp_fail;
		out item normal;
		out item raw_sen_data;

		first start;
		then fork;
			then rcv_power_off;
			then rcv_initialization_completed;

		action rcv_power_off accept power_off: Power_OFF;
		then done;
		action rcv_initialization_completed accept initialization_completed: Initialization_Completed;
		then merge ContinuousLoop;
			then action acquire_yaw_motion: AcquireYawMotion {
				in item vm = detect_yaw_moment.vm;
				out item raw_sen_data;
			}

			then decide;
				if ((acquire_yaw_motion.raw_sen_data > 127.75) || (acquire_yaw_motion.raw_sen_data < -128.00)) then determine_temp_fail;
				if ((acquire_yaw_motion.raw_sen_data <= 127.75) && (acquire_yaw_motion.raw_sen_data >= -128.00)) then determine_normal_data;

			action determine_temp_fail: DetermineTemporaryFail {
				out item temp_fail = detect_yaw_moment.temp_fail;
				out item num_of_fail;
			}
			then action wait_100ms: Wait100Ms;
			then decide;
				if (determine_temp_fail.num_of_fail >= 3) then done;
				if (determine_temp_fail.num_of_fail < 3) then ContinuousLoop;

			action determine_normal_data: DetermineNormalData {
				in item raw_sen_data_in flow from acquire_yaw_motion.raw_sen_data;
				out item raw_sen_data: Raw_Sen_Data = detect_yaw_moment.raw_sen_data;
				out item normal: Data_Status = detect_yaw_moment.normal;
			}
			then action wait2_100ms: Wait100Ms;
			then ContinuousLoop;
	}
	action stop_detect_yaw_moment: StopDetectingYawMoment {
		out item perm_fail;

		first start;
		then fork;
			then rcv_power_off;
			then rcv_initialization_completed;

		action rcv_power_off accept power_off: Power_OFF;
		then done;
		action rcv_initialization_completed accept initialization_completed: Initialization_Completed;
		then action rcv_sensor_failed accept sensor_failed: Sensor_Failed;
		then merge ContinuousLoop;
			then action determine_perm_fail: DeterminePermanentFail {
				out item perm_fail = stop_detect_yaw_moment.perm_fail;
			}
			then action wait_100ms: Wait100Ms;
			then ContinuousLoop;
	}
	action transmit_sensing_data: TransmitSensingData {
		in item data_status;
		in item raw_sen_data;
		out item can_data;

		first start;
		then fork;
			then rcv_power_off;
			then rcv_initialization_completed;

		action rcv_power_off accept power_off: Power_OFF;
		then done;
		action rcv_initialization_completed accept initialization_completed: Initialization_Completed;
		then merge ContinuousLoop;
			then decide;
				if (data_status == 0) then generate_normal_data;
				if (data_status == 1) then generate_default_data;
				if (data_status == 2) then generate_perm_fail;
				if (data_status == 3) then generate_temp_fail;
			then merge CombinePath;
			then action format_data: FormatData{
				in item sen_data_normal flow from generate_normal_data.sen_data;
				in item sen_data_default flow from generate_default_data.sen_data;
				in item sen_data_temp_fail flow from generate_temp_fail.sen_data;
				in item sen_data_perm_fail flow from generate_perm_fail.sen_data;
				out item can_data;
			}
			then action output_can_data: OutputCanDat {
				in item can_data_in flow from format_data.can_data;
				out item can_data = transmit_sensing_data.can_data;
			}
			then ContinuousLoop;

		action generate_normal_data: GenerateNormalData {
			in item raw_sen_data_in = transmit_sensing_data.raw_sen_data;
			out item sen_data;
		}
		then CombinePath;

		action generate_default_data: GenerateDefaultData {
			out item sen_data;
		}
		then CombinePath;

		action generate_perm_fail: GeneratePermanentFail {
			out item sen_data;
		}
		then CombinePath;
		action generate_temp_fail: GenerateTemporaryFail {
			out item sen_data;
		}
		then CombinePath;
	}
}
