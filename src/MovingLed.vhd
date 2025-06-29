----------------------------------------------------------------------------------
--
-- Name: MovingLed
-- Authors: Abhijeet Surakanti, Salini Ambadapudi
--
--     This is a synchronous component that implements the logic to move an
--     LED signal over a linear array controlled by two pulse-enabled signals.
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MovingLed is
	port (
		moveLeftEn: in std_logic;
		moveRightEn: in std_logic;
		reset: in std_logic;
		clock: in std_logic;

		leds: out std_logic_vector(15 downto 0);
		ledNum: out std_logic_vector(3 downto 0)
	);
end MovingLed;

architecture MovingLed_ARCH of MovingLed is

	-- Constants
	constant ACTIVE: std_logic := '1';

	-- internal signals
	signal ledIndex: unsigned(3 downto 0);

begin

	LED_INDEXER: process(reset, clock)

	begin

		if (reset = ACTIVE) then
			ledIndex <= (others => '0');
		elsif (rising_edge(clock)) then
			if (not (moveLeftEn = ACTIVE and moveRightEn = ACTIVE)) then
				if (moveLeftEn = ACTIVE) then
					if (ledIndex /= 15) then
						ledIndex <= ledIndex + 1;
					end if;
				elsif (moveRightEn = ACTIVE) then
					if (ledIndex /= 0) then
						ledIndex <= ledIndex - 1;
					end if;
				end if;
			end if;
		end if;

	end process;

	ledNum <= std_logic_vector(ledIndex);

	LED_DRIVER: process(ledIndex)

		variable temp: std_logic_vector(15 downto 0);

	begin

		temp := (others => '0');

		temp(to_integer(unsigned(ledIndex))) := ACTIVE;

		leds <= temp;

	end process;

end MovingLed_ARCH;
