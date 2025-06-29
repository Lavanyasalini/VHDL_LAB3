library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MovingLed_BASYS3 is
	port (
		clk: in std_logic;
		reset: in std_logic;
		btnL: in std_logic;
		btnR: in std_logic;
		led: out std_logic_vector(15 downto 0)
	);
end MovingLed_BASYS3;

architecture MovingLed_BASYS3_ARCH of MovingLed_BASYS3 is

	-- constants
	constant ACTIVE: std_logic:= '1';

	-- internal signals
	signal syncedLeftButton: std_logic;
	signal syncedRightButton: std_logic;

	signal moveLeftEn: std_logic;
	signal moveRightEn: std_logic;

	signal unusedLedNum: std_logic_vector(3 downto 0);

	-- components
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

	component ButtonSync
		port (
			button: in std_logic;
			reset: in std_logic;
			clock: in std_logic;

			syncedButton: out std_logic
		);
	end component;

	component ButtonPulser
		port (
			syncedButton: in std_logic;
			reset: in std_logic;
			clock: in std_logic;

			buttonPulse: out std_logic
		);
	end component;

begin

	LEFT_BUTTON_SYNC: ButtonSync
		port map (
			button => btnL,
			reset => reset,
			clock => clk,
			syncedButton => syncedLeftButton
		);

	LEFT_BUTTON_PULSER: ButtonPulser
		port map (
			syncedButton => syncedLeftButton,
			reset => reset,
			clock => clk,
			buttonPulse => moveLeftEn
		);

	RIGHT_BUTTON_SYNC: ButtonSync
		port map (
			button => btnR,
			reset => reset,
			clock => clk,
			syncedButton => syncedRightButton
		);

	RIGHT_BUTTON_PULSER: ButtonPulser
		port map (
			syncedButton => syncedRightButton,
			reset => reset,
			clock => clk,
			buttonPulse => moveRightEn
		);

	UUT: MovingLed
		port map (
			moveLeftEn => moveLeftEn,
			moveRightEn => moveRightEn,
			reset => reset,
			clock => clk,
			leds => led,
			ledNum => unusedLedNum
		);

end MovingLed_BASYS3_ARCH;
