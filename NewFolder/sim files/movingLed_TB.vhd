----------------------------------------------------------------------------------
--
--     Test bench file. 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity MovingLed_TB is
end MovingLed_TB;

architecture MovingLed_TB_ARCH of MovingLed_TB is

	----general definitions----------------------------------------------CONSTANTS
	constant ACTIVE: std_logic := '1';

	-- UUT
	component MovingLed
		port (
			moveLeftEn: in std_logic;
			moveRightEn: in std_logic;
			reset: in std_logic;
			clock: in std_logic;
			leds: out std_logic_vector(15 downto 0);
			ledNum: out std_logic_vector(3 downto 0)
		);
	end component;

	-- uut-signals
	signal moveLeftEn: std_logic;
	signal moveRightEn: std_logic;
	signal reset: std_logic;
	signal clock: std_logic;
	signal leds: std_logic_vector(15 downto 0);
	signal ledNum: std_logic_vector(3 downto 0);

begin

	UUT:
		MovingLed port map(
			moveLeftEn => moveLeftEn,
			moveRightEn => moveRightEn,
			reset => reset,
			clock => clock,
			leds => leds,
			ledNum => ledNum
		);

	--============================================================================
	--  Reset
	--============================================================================
	SYSTEM_RESET: process
	begin
		reset <= ACTIVE;
		wait for 15 ns;
		reset <= not ACTIVE;
		wait;
	end process SYSTEM_RESET;


	--============================================================================
	--  Clock
	--============================================================================
	SYSTEM_CLOCK: process
	begin
		clock <= not ACTIVE;
		wait for 5 ns;
		clock <= ACTIVE;
		wait for 5 ns;
	end process SYSTEM_CLOCK;

	INPUT_DRIVER: process(reset, clock)
		variable inputVector : std_logic_vector(1 downto 0);

	begin

		if (reset = ACTIVE) then
			inputVector := (others => '0');
		elsif (rising_edge(clock)) then
			if (inputVector /= "11") then
				inputVector := std_logic_vector(unsigned(inputVector) + 1);
			end if;
		end if;

		moveLeftEn <= inputVector(1);
		moveRightEn <= inputVector(0);
	end process;

end MovingLed_TB_ARCH;
