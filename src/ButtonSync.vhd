----------------------------------------------------------------------------------
--
-- Name: ButtonSync
-- Authors: Abhijeet Surakanti, Salini Ambadapudi
--
--     This connects an asynchronous input(button) to an output
--     flip-flop(syncedButton). There could be metastability with the output
--     being  unresolved (between 0 and 1) if button changes value near clock's
--     rising edge.
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ButtonSync is
	port (
		button: in std_logic;
		reset: in std_logic;
		clock: in std_logic;

		syncedButton: out std_logic
	);
end ButtonSync;

architecture ButtonSync_ARCH of ButtonSync is

	-- constants
	constant ACTIVE: std_logic := '1';

	-- internal signals
	signal holdButtonState: std_logic;

begin

	SYNC_BUTTON: process(reset, clock)
	begin

		if (reset = ACTIVE) then
			holdButtonState <= not ACTIVE;
			syncedButton <= not ACTIVE;
		elsif (rising_edge(clock)) then
			holdButtonState <= button;
			syncedButton <= holdButtonState;
		end if;

	end process;

end ButtonSync_ARCH;
