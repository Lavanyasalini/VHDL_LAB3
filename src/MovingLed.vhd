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

	----general definitions----------------------------------------------CONSTANTS
	constant ACTIVE: std_logic := '1';

	signal ledIndex: std_logic_vector(3 downto 0);

begin

	LED_INDEXER: process(reset, clock)

		variable count: integer range 0 to 15;

	begin

		if (reset = ACTIVE) then
			count := 0;
		elsif (rising_edge(clock)) then
			if (moveLeftEn /= ACTIVE or moveRightEn /= ACTIVE) then
				if (moveLeftEn = ACTIVE) then
					if (count /= 15) then
						count := count + 1;
					end if;
				elsif (moveRightEn = ACTIVE) then
					if (count /= 0) then
						count := count - 1;
					end if;
				end if;
			end if;
		end if;

		ledIndex <= std_logic_vector(to_unsigned(count, 4));

	end process;

	ledNum <= ledIndex;

	LED_DRIVER: process(ledIndex)

		variable temp: std_logic_vector(15 downto 0);

	begin

		temp := (others => '0');
		
		temp(to_integer(unsigned(ledIndex))) := ACTIVE;

		leds <= temp;

	end process;

end MovingLed_ARCH;
