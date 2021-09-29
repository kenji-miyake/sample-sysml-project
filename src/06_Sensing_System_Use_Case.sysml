// https://github.com/Systems-Modeling/SysML-v2-Release 2021-08

package 'Sensing System Use Case'
{
	import 'Sensing System Context'::*;
	
	use case 'Start the System' {
		subject sensing_system: Sensing_System[1];
		actor vm: Vehicle_Motion[1];
		actor act: Actuator_System[1];
		objective {
			doc /* Vehicle Motion and Actuator system want
			 	 * Sensing System to start the system.
			 	 */
		}
	}
	
	use case 'Stop the System' {
		subject sensing_system: Sensing_System[1];
		actor vm: Vehicle_Motion[1];
		actor act: Actuator_System[1];
		objective {
			doc /* Vehicle Motion and Actuator system want
			 	 * Sensing System to stop the system.
			 	 */
		}
	}
	
	use case 'Detect the Yaw Moment' {
		subject sensing_system: Sensing_System[1];
		actor vm: Vehicle_Motion[1];
		objective {
			doc /* Vehicle Motion wants Sensing System
			 	 * to detect the yaw moment.
			 	 */
		}
	}
	
	use case 'Stop Detecting the Yaw Moment' {
		subject sensing_system: Sensing_System[1];
		actor vm: Vehicle_Motion[1];
		objective {
			doc /* Vehicle Motion wants Sensing System
			 	 * to stop detecting the yaw moment.
			 	 */
		}
	}
	
	use case 'Transmit the Sensing Data' {
		subject sensing_system: Sensing_System[1];
		actor act: Actuator_System[1];
		objective {
			doc /* Actuator System wants Sensing System
			 	 * to transmit the sensing data.
			 	 */
		}
	}
}
