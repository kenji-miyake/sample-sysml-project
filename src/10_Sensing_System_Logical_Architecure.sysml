// https://github.com/Systems-Modeling/SysML-v2-Release 2021-08

package 'Sensing System Logical Architecture'
{
    import 'Sensing System Base Architecture'::*;
    import 'Sensing System Context'::*;
    import 'Sensing System Domain Knowledge'::*;

    // ====================================
    // Definitions of System Logical Architecture Context
    // ====================================
    part def Sensing_System_Logical_Architecture_Context :> Sensing_System_Context {
        part sensing_system_log_arch: Sensing_System_Logical_Architecture[1];
    }

    // ====================================
    // Definitions of System Logical Architecture
    // ====================================
    part arch_cxt: Sensing_System_Logical_Architecture_Context;
    part def Sensing_System_Logical_Architecture :> Sensing_System {
        // Part
        part mcu: MCU[1];
        part gs: Gyro_Sensor[1];
        part can: CAN_Transceiver[1];
        part pr: Power_Regulator[1];
        part rg: Reset_Generator[1];
        part wdg: External_Watchdog[1];

        // Port
        port p_in_ext_pwr: IF_ExtPwr;
        port p_in_vm: IF_VehicleMotion;
        port p_out_can: IF_CanSenData;

        // ====================================
        // Definitions of Interfaces (Connection and flow oriented view)
        // ====================================
        // External Interfaces
        interface: IF_DEF_EXT_VehicleMotion connect
            if_in_vm :> p_in_vm to
            if_int_in_vm :> gs.p_in_vm;
        interface: IF_DEF_EXT_CanSenData connect
            if_int_out_can :> can.p_out_can to
            if_out_can :> p_out_can;

        // Internal Interfaces
        interface: IF_DEF_INT_RawSenData connect
            if_int_out_raw_sen_data :> gs.p_out_raw_sen_data to
            if_int_in_raw_sen_data :> mcu.p_in_raw_sen_data;
        interface: IF_DEF_INT_SenData connect
            if_int_out_sen_data :> mcu.p_out_sen_data to
            if_int_in_sen_data :> can.p_in_sen_data;
        interface: IF_DEF_INT_ResetSig connect
            if_int_out_reset_sig :> rg.p_out_reset_sig to
            if_int_in_reset_sig :> mcu.p_in_reset_sig;
        interface: IF_DEF_INT_WdgReset connect
            if_int_out_wdg_reset :> wdg.p_out_wdg_reset to
            if_int_in_wdg_reset :> mcu.p_in_wdg_reset;

        // ====================================
        // Definitions of Interfaces (Power supply connection and flow oriented view)
        // ====================================
        // External Interfaces
        interface: IF_DEF_ExtPwr connect
            if_in_ext_pwr :> p_in_ext_pwr to
            if_int_in_ext_pwr :> pr.p_in_ext_pwr;

        // Internal Interfaces
        interface: IF_DEF_INT_RegPwr connect
            if_int_out_reg_pwr :> pr.p_out_reg_pwr to
            if_int_in_reg_pwr :> mcu.p_in_reg_pwr;
        interface: IF_DEF_INT_RegPwr connect
            if_int_out_reg_pwr :> pr.p_out_reg_pwr to
            if_int_in_reg_pwr :> gs.p_in_reg_pwr;
        interface: IF_DEF_INT_RegPwr connect
            if_int_out_reg_pwr :> pr.p_out_reg_pwr to
            if_int_in_reg_pwr :> can.p_in_reg_pwr;
        interface: IF_DEF_INT_RegPwr connect
            if_int_out_reg_pwr :> pr.p_out_reg_pwr to
            if_int_in_reg_pwr :> rg.p_in_reg_pwr;
        interface: IF_DEF_INT_RegPwr connect
            if_int_out_reg_pwr :> pr.p_out_reg_pwr to
            if_int_in_reg_pwr :> wdg.p_in_reg_pwr;
    }

    // ====================================
    // Definitions of Parts in System
    // ====================================
    part def MCU {
        port p_in_raw_sen_data: IF_INT_RawSenData;
        port p_in_reg_pwr: IF_INT_RegPwr;
        port p_in_reset_sig: IF_INT_ResetSig;
        port p_in_wdg_reset: IF_INT_WdgReset;
        port p_out_sen_data: IF_INT_SenData;
    }
    part def Gyro_Sensor {
        port p_in_reg_pwr: IF_INT_RegPwr;
        port p_in_vm: IF_VehicleMotion;
        port p_out_raw_sen_data: ~IF_INT_RawSenData;
    }
    part def CAN_Transceiver {
        port p_in_reg_pwr: IF_INT_RegPwr;
        port p_in_sen_data: ~IF_INT_SenData;
        port p_out_can: IF_CanSenData;
    }
    part def Power_Regulator {
        port p_in_ext_pwr: IF_ExtPwr;
        port p_out_reg_pwr: ~IF_INT_RegPwr;
    }
    part def Reset_Generator {
        port p_in_reg_pwr: IF_INT_RegPwr;
        port p_out_reset_sig: ~IF_INT_ResetSig;
    }
    part def External_Watchdog {
        port p_in_reg_pwr: IF_INT_RegPwr;
        port p_out_wdg_reset: ~IF_INT_WdgReset;
    }

    // ====================================
    // Definitions of Interfaces (Connection and flow oriented view)
    // ====================================
    interface def IF_DEF_EXT_VehicleMotion {
        end if_in_vm: IF_VehicleMotion;
        end if_int_in_vm: IF_VehicleMotion;
    }
    interface def IF_DEF_EXT_CanSenData {
        end if_int_out_can: IF_CanSenData;
        end if_out_can: IF_CanSenData;
    }
    interface def IF_DEF_INT_RawSenData {
        end if_int_out_raw_sen_data: ~IF_INT_RawSenData;
        end if_int_in_raw_sen_data: IF_INT_RawSenData;
    }
    interface def IF_DEF_INT_SenData {
        end if_int_out_sen_data: IF_INT_SenData;
        end if_int_in_sen_data: ~IF_INT_SenData;
    }
    interface def IF_DEF_INT_ResetSig {
        end if_int_out_reset_sig: ~IF_INT_ResetSig;
        end if_int_in_reset_sig: IF_INT_ResetSig;
    }
    interface def IF_DEF_INT_WdgReset {
        end if_int_out_wdg_reset: ~IF_INT_WdgReset;
        end if_int_in_wdg_reset: IF_INT_WdgReset;
    }

    // ====================================
    // Definitions of Interfaces (Power supply connection and flow oriented view)
    // ====================================
    interface def IF_DEF_ExtPwr {
        end if_in_ext_pwr: IF_ExtPwr;
        end if_int_in_ext_pwr: IF_ExtPwr;
    }
    interface def IF_DEF_INT_RegPwr {
        end if_int_out_reg_pwr: ~IF_INT_RegPwr;
        end if_int_in_reg_pwr: IF_INT_RegPwr;
    }
}
