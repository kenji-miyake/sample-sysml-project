package 'Sensing System Processes'
{
	import 'Sensing System Use Case Activity'::*;

	action def PerformSystemProcess;

	action perform_system_process: PerformSystemProcess {
		first start;

		then action rcv_power_on accept power_on: Power_ON;
		then fork;
			then start_system;
			then detect_yaw_moment;
			then stop_detect_yaw_moment;
			then transmit_sensing_data;

		join JoinNode;
		then stop_system;

		action start_system: StartSystem;
		then JoinNode;
		action detect_yaw_moment: DetectYawMoment;
		then JoinNode;
		action stop_detect_yaw_moment: StopDetectingYawMoment;
		then JoinNode;
		action transmit_sensing_data: TransmitSensingData;
		then JoinNode;
		action stop_system: StopSystem;
		then done;
	}
}
