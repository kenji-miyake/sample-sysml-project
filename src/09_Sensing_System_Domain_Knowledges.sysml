package 'Sensing System Domain Knowledges'
{
	// ====================================
	// Definitions of Sensing System Domain Knowledge
	// ====================================
	item def Raw_Sen_Data;
	item def Regulated_Power_Supply;
	item def Reset_Signal;
	item def Num_Of_Fail;
	item def Sen_Data;
	item def Watchdog_Reset;
	port def IF_INT_RawSenData {
		in item fp_raw_sen_data: Raw_Sen_Data;
	}
	port def IF_INT_RegPwr {
		in item fp_reg_pwr: Regulated_Power_Supply;
	}
	port def IF_INT_ResetSig {
		in item fp_reset_sig: Reset_Signal;
	}
	port def IF_INT_SenData {
		out item fp_sen_data: Sen_Data;
	}
	port def IF_INT_WdgReset {
		in item fp_wdg_reset: Watchdog_Reset;
	}
	item def Data_Status;

	// ====================================
	// Definitions of Context Domain Knowledge
	// ====================================
	item def CAN_Sen_Data;
	item def External_Power_Supply;
	item def Vehicle_Motion;
	port def IF_CanSenData {
		out item fp_can_sen_data: CAN_Sen_Data;
	}
	port def IF_ExtPwr {
		in item fp_ext_pwr: External_Power_Supply;
	}
	port def IF_VehicleMotion {
		in item fp_vm: Vehicle_Motion;
	}
}
