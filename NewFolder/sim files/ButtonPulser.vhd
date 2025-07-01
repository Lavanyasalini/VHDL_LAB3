----------------------------------------------------------------------------------
--
-- Name: ButtonPulser
-- Authors: Abhijeet Surakanti, Salini Ambadapudi
--
--     This component debounces a button input and provides a stable output
--     suitable for controlling a state machine, filtering out mechanical bounce.
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ButtonPulser is
    port (
        reset:           in  std_logic;
        clock:           in  std_logic;
        syncedButton:    in  std_logic;
        buttonPulse:     out std_logic
    );
end ButtonPulser;

architecture ButtonPulser_ARCH of ButtonPulser is
    constant ACTIVE: std_logic := '1';
    constant TIME_BETWEEN_PULSES: integer := 12;
    constant CLOCK_FREQUENCY: integer := 100_000_000;
    signal pulse: std_logic;

    constant COUNT_BETWEEN_PULSES: integer := (CLOCK_FREQUENCY/TIME_BETWEEN_PULSES) - 1;

    type States_t is (WAIT_FOR_INPUT, OUTPUT, WAIT_FOR_CONDITIONS);
    signal currentState: States_t;
    signal nextState:    States_t;
begin

    PULSE_GENERATOR: process(reset, clock)
    variable count: integer range 0 to COUNT_BETWEEN_PULSES;
    begin
        if (reset = ACTIVE) then
            count := 0;
        elsif rising_edge(clock) then
            if (count = COUNT_BETWEEN_PULSES) then
                count := 0;
                pulse <= ACTIVE;
            else
                count := count + 1;
                pulse <= not ACTIVE;
            end if;
        end if;
    end process;

    STATE_REGISTER: process(reset, clock)
    begin
        if (reset = ACTIVE) then
            currentState <= WAIT_FOR_INPUT;
        elsif rising_edge(clock) then
            currentState <= nextState;
        end if;
    end process;

    STATE_TRANSITION: process(currentState, syncedButton, pulse)
    begin
        buttonPulse <= not ACTIVE;
        nextState <= currentState;

        case currentState is
            when WAIT_FOR_INPUT =>
                if syncedButton = ACTIVE then
                    nextState <= OUTPUT;
                end if;

            when OUTPUT =>
                buttonPulse <= ACTIVE;
                nextState <= WAIT_FOR_CONDITIONS;

            when WAIT_FOR_CONDITIONS =>
                if syncedButton = not ACTIVE and pulse = ACTIVE then
                    nextState <= WAIT_FOR_INPUT;
                end if;
        end case;
    end process;
end ButtonPulser_ARCH;
