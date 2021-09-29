// https://github.com/Systems-Modeling/SysML-v2-Release 2021-08

package 'Sensing System Context'
{
	import 'Sensing System Base Architecture'::*;

	// ====================================
	// Definitions of System Context
	// ====================================
	part def Sensing_System_Context :> Base_Sensing_System_Architecture_Context {
		part sensing_system: Sensing_System[1];
		part act: Actuator_System[1];
		part vm: Vehicle_Motion[1];
		connection: SensingDataDetection connect vm to sensing_system;
		connection: SensingDataOutput connect sensing_system to act;
	}
	part def Sensing_System :> Base_Sensing_System;
	part def Actuator_System;
	part def Vehicle_Motion;

	// ====================================
	// Definitions of Connections
	// ====================================
	connection def SensingDataDetection {
		end : Vehicle_Motion[1];
		end : Sensing_System[1];
	}
	connection def SensingDataOutput {
		end: Sensing_System[1];
		end: Actuator_System[1];
	}
}
