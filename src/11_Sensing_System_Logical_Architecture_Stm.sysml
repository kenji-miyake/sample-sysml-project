// https://github.com/Systems-Modeling/SysML-v2-Release 2021-08

package 'Sensing System Logical Architecture State Machine'
{
    state def Sensing_System_States;

    attribute def TRG_Power_ON;
    attribute def TRG_Power_OFF;
    attribute def TRG_Initialization_Completed;
    attribute def TRG_Sensor_Failed;

    state sensing_system_states: Sensing_System_States {
        // Entry
        entry; then Power_OFF_State;
        // State
        state Power_OFF_State;
        accept TRG_Power_ON then Power_ON_State;

        state Power_ON_State {
            // Entry
            entry; then Initialization_State;
            // State
            state Initialization_State;
            accept TRG_Initialization_Completed then Runtime_State;
            state Runtime_State {
                // Entry
                entry; then Normal_State;
                // State
                state Normal_State;
                accept TRG_Sensor_Failed then Fail_State;
                state Fail_State;
            }
        }
        accept TRG_Power_OFF then Power_OFF_State;
    }
}
