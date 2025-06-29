----------------------------------------------------------------------------------
--
-- Name: ButtonPulser
-- Authors: Abhijeet Surakanti, Salini Ambadapudi
--
--     This component processes the synchronized button signals and generates
--     pulses accordingly.
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ButtonPulser is
	port (
		syncedButton: in std_logic;
		reset: in std_logic;
		clock: in std_logic;

		buttonPulse: out std_logic
	);
end ButtonPulser;

architecture ButtonPulser_ARCH of ButtonPulser is

	-- constants
	constant ACTIVE: std_logic := '1';

	-- internal signals
	signal prevButtonValue: std_logic;

begin

	PULSE_BUTTON: process(reset, clock)

	begin

		if (reset = ACTIVE) then

			buttonPulse <= not ACTIVE;
			prevButtonValue <= not ACTIVE;

		elsif (rising_edge(clock)) then

			if (syncedButton = ACTIVE and prevButtonValue /= ACTIVE) then
				buttonPulse <= ACTIVE;
			else
				buttonPulse <= not ACTIVE;
			end if;

			prevButtonValue <= syncedButton;

		end if;

	end process;

end ButtonPulser_ARCH;
