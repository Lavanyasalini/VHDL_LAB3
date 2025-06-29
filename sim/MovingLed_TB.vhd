library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity MovingLed_TB is
end MovingLed_TB;

architecture MovingLed_TB_ARCH of MovingLed_TB is

	-- constants
	constant ACTIVE: std_logic := '1';

	-- test types declaration
	type testRecord_t is record
		moveLeftEn: std_logic;
		moveRightEn: std_logic;
	end record;
	type testArray_t is array(natural range <>) of testRecord_t;

	-- test-vectors
	constant TEST_VECTORS: testArray_t := (
		--moveLeftEn--moveRightEn---
		(     '0',       '1'    ), -- try to move right from zero
		-- go all the left
		(     '1',       '0'    ),
		(     '1',       '0'    ),
		(     '1',       '0'    ),
		(     '1',       '0'    ),
		(     '1',       '0'    ),
		(     '1',       '0'    ),
		(     '1',       '0'    ),
		(     '1',       '0'    ),
		(     '1',       '0'    ),
		(     '1',       '0'    ),
		(     '1',       '0'    ),
		(     '1',       '0'    ),
		(     '1',       '0'    ),
		(     '1',       '0'    ),
		(     '1',       '0'    ),
		(     '1',       '0'    ),
		-- try going left at wall
		(     '1',       '0'    ),
		-- go near mid point (led(7))
		(     '0',       '1'    ),
		(     '0',       '1'    ),
		(     '0',       '1'    ),
		(     '0',       '1'    ),
		(     '0',       '1'    ),
		(     '0',       '1'    ),
		(     '0',       '1'    ),
		(     '0',       '1'    ),
		-- try both buttons
		(     '1',       '1'    ),
		-- do nothing (should be same as above)
		(     '0',       '0'    ),
		-- little dance
		(     '1',       '0'    ),
		(     '0',       '1'    ),
		(     '0',       '1'    ),
		(     '1',       '0'    )
);

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
		variable index: natural;

	begin

		if (reset = ACTIVE) then
			moveLeftEn <= not ACTIVE;
			moveRightEn <= not ACTIVE;
			index := 0;
		elsif (rising_edge(clock)) then
			if (index < TEST_VECTORS'Length) then
				moveLeftEn <= TEST_VECTORS(index).moveLeftEn;
				moveRightEn <= TEST_VECTORS(index).moveRightEn;
				index := index + 1;
			end if;
		end if;
	end process;

end MovingLed_TB_ARCH;
