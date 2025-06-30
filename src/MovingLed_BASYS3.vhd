library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MovingLed_BASYS3 is
	port (
		clk: in std_logic;
		reset: in std_logic;
		btnL: in std_logic;
		btnR: in std_logic;
		led: out std_logic_vector(15 downto 0);
		seg: out std_logic_vector(6 downto 0);
		dp: out std_logic;
		an: out std_logic_vector(3 downto 0)
	);
end MovingLed_BASYS3;

architecture MovingLed_BASYS3_ARCH of MovingLed_BASYS3 is

	----constants----------------------------------------------------------
	constant ACTIVE: std_logic:= '0';

	----internal connections-----------------------------------------------
	-- button related
	signal syncedLeftButton: std_logic;
	signal syncedRightButton: std_logic;
	signal moveLeftEn: std_logic;
	signal moveRightEn: std_logic;

	-- uut related
	signal ledNum: unsigned(3 downto 0);

	-- segment related
	signal digit1: std_logic_vector(3 downto 0);
	signal digit0: std_logic_vector(3 downto 0);

	----components---------------------------------------------------------
	component MovingLed
		port (
			moveLeftEn: in std_logic;
			moveRightEn: in std_logic;
			reset: in std_logic;
			clock: in std_logic;

			leds: out std_logic_vector(15 downto 0);
			ledNum: out unsigned(3 downto 0)
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

	component SevenSegmentDriver
		port (
			reset: in std_logic;
			clock: in std_logic;

			digit3: in std_logic_vector(3 downto 0);    --leftmost digit
			digit2: in std_logic_vector(3 downto 0);    --2nd from left digit
			digit1: in std_logic_vector(3 downto 0);    --3rd from left digit
			digit0: in std_logic_vector(3 downto 0);    --rightmost digit

			blank3: in std_logic;    --leftmost digit
			blank2: in std_logic;    --2nd from left digit
			blank1: in std_logic;    --3rd from left digit
			blank0: in std_logic;    --rightmost digit

			sevenSegs: out std_logic_vector(6 downto 0);    --MSB=g, LSB=a
			anodes:    out std_logic_vector(3 downto 0)    --MSB=leftmost digit
	);
	end component;

begin

	--============================================================================
	--  Button synchronization and pulsing
	--============================================================================

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

	--============================================================================
	--  Actual logic
	--============================================================================

	UUT: MovingLed
		port map (
			moveLeftEn => moveLeftEn,
			moveRightEn => moveRightEn,
			reset => reset,
			clock => clk,
			leds => led,
			ledNum => ledNum
		);

	--============================================================================
	--  Segment related code
	--============================================================================

	-- Set constant signal
	dp <= ACTIVE;

	CONVERT_TO_BCD: process(ledNum)
	begin
		if (ledNum < 10) then
			digit1 <= (others => '0');
			digit0 <= std_logic_vector(ledNum);
		else
			digit1 <= "0001";
			digit0 <= std_logic_vector(ledNum mod 10);
		end if;
	end process;

	SEGMENT_DRIVER: SevenSegmentDriver
		port map (
			reset => reset,
			clock => clk,

			digit3 => std_logic_vector(ledNum),
			digit2 => (others => not ACTIVE),
			digit1 => digit1,
			digit0 => digit0,

			blank3 => ACTIVE,
			blank2 => not ACTIVE,
			blank1 => ACTIVE,
			blank0 => ACTIVE,

			sevenSegs => seg,
			anodes => an
	);

end MovingLed_BASYS3_ARCH;
