// https://github.com/Systems-Modeling/SysML-v2-Release 2021-08

package 'Sensing System Requirements'
{
	import 'Sensing System Context'::*;

	// ====================================
	// Definitions of Requirements
	// ====================================
	requirement SensingSystemRequirements {
		doc /* Overall Sensing System Requirements */
		subject sensing_system: Sensing_System[1];
		requirement InitializationRequirements {
			doc /* Sensing System Initialization Requirements */
			requirement req_init_01: REQ_INIT_01;
			requirement req_init_02: REQ_INIT_02;
		}
		requirement FinalizationRequirements {
			doc /* Sensing System Finalization Requirements */
			requirement req_final_01: REQ_FINAL_01;
		}
		requirement SensingRequirements {
			doc /* Sensing System Sensing Requirements */
			requirement req_sen_01: REQ_SEN_01;
		}
		requirement CommunicationRequirements {
			doc /* Sensing System Communication Requirements */
			requirement req_com_01: REQ_COM_01;
			requirement req_com_02: REQ_COM_02;
			requirement req_com_03: REQ_COM_03;
			requirement req_com_04: REQ_COM_04;
			requirement req_com_05: REQ_COM_05;
			requirement req_com_06: REQ_COM_06;
			requirement req_com_07: REQ_COM_07;
		}
	}

	// ====================================
	// Definitions of Requirement Definition
	// ====================================
	requirement def id 'REQ_INIT_01' REQ_INIT_01 {
		doc /* When the ignition turns on, the Sensing System shall be powered on. */
	}
	requirement def id 'REQ_INIT_02' REQ_INIT_02 {
		doc /* After the power on, the Sensing System shall initialize its sensors. */
	}
	requirement def id 'REQ_FINAL_01' REQ_FINAL_01 {
		doc /* When the ignition turns off, the Sensing System shall be powered off. */
	}
	requirement def id 'REQ_SEN_01' REQ_SEN_01 {
		doc /* After the initialization, the Sensing System shall detect the yaw moment of the vehicle
		       (Required detection range: -128.0 deg/s~+127.75 deg/s,
		       "-": counter clockwise, "+": clockwise, a
		       Required resolution: 0.25deg/s per unit) every 100ms.
		*/
	}
	requirement def id 'REQ_COM_01' REQ_COM_01 {
		doc /* After the power on, the Sensing System shall transmit the yaw rate data with CAN message
		       (ID: 100h (Standard Message), Data size: 2byte data) every 100ms.
		*/
	}
	requirement def id 'REQ_COM_02' REQ_COM_02 {
		doc /* During the initialization, the Sensing System shall transmit the data 0200h.
		       (0200h: Initial value (=+-0.00 deg/s))
		 */
	}
	requirement def id 'REQ_COM_03' REQ_COM_03 {
		doc /* After the initialization, Sensing System shall generate the payload data with the following formula:
		       (((sensing data) / 0.25) + 512)
		       if the sensing data is in valid range (#).
		       (#) If the sensors can detect wider ranges
		           (i.e. less than -128.00 deg/s or more than +127.75deg/s,
		           the value shall be rounded (i.e. fixed -128.00 deg/s or fixed +127.75deg/s).
		*/
	}
	requirement def id 'REQ_COM_04' REQ_COM_04 {
		doc /* After the payload data generation, the Sensing System shall transmit the data (0000h~03FFh). */
	}
	requirement def id 'REQ_COM_05' REQ_COM_05 {
		doc /* After the initialization, the Sensing System shall transmit the data 0FFFh
		       if the sensing data is out of valid range.
               (0FFFh: temporary failure)
        */
	}
	requirement def id 'REQ_COM_06' REQ_COM_06 {
		doc /* The Sensing System shall stop detecting the yaw moment of the vehicle
		       if the Sensing System shall detect three successive invalid range of sensing data.
		*/
	}
	requirement def id 'REQ_COM_07' REQ_COM_07 {
		doc /* After stop of detection, the Sensing System shall transmit the data FFFFh.
		       (FFFFh: permanent failure)
		 */
	}
}
