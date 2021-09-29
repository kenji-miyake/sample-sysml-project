// https://github.com/Systems-Modeling/SysML-v2-Release 2021-08

package 'Sensing System Base Architecture'
{
	// ====================================
	// Definitions of Base System Context
	// ====================================
	part def Base_Sensing_System_Architecture_Context {
		part base_sensing_system: Base_Sensing_System[1];
		part base_act: Base_Actuator_System[1];
		part base_vm: Base_Vehicle_Motion[1];
		connection: BaseSensingDataDetection connect base_vm to base_sensing_system;
		connection: BaseSensingDataOutput connect base_sensing_system to base_act;
	}

	// ====================================
	// Definitions of Parts in Base System Context
	// ====================================
	part def Base_Sensing_System {
		part base_mcu: Base_MCU[1];
		part base_gs: Base_Gyro_Sensor[1];
		part base_can: Base_CAN_Transceiver[1];
		part base_pr: Base_Power_Regulator[1];
		part base_rg: Base_Reset_Generator[1];
		part base_wdg: Base_External_Watchdog[1];
	}
	part def Base_Actuator_System;
	part def Base_Vehicle_Motion;

	// ====================================
	// Definitions of Parts in Base System
	// ====================================
	part def Base_MCU;
	part def Base_Gyro_Sensor;
	part def Base_CAN_Transceiver;
	part def Base_Power_Regulator;
	part def Base_Reset_Generator;
	part def Base_External_Watchdog;

	// ====================================
	// Definitions of Connections
	// ====================================
	connection def BaseSensingDataDetection {
		end : Base_Vehicle_Motion[1];
		end : Base_Sensing_System[1];
	}
	connection def BaseSensingDataOutput {
		end: Base_Sensing_System[1];
		end: Base_Actuator_System[1];
	}
}
