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

	-- constants
	constant ACTIVE: std_logic:= '1';

	-- internal signals
	signal syncedLeftButton: std_logic;
	signal syncedRightButton: std_logic;

	signal moveLeftEn: std_logic;
	signal moveRightEn: std_logic;

	signal ledNum: std_logic_vector(3 downto 0);

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

	----normal seven segment display-------------------------------------CONSTANTS
    constant ZERO_7SEG: std_logic_vector(6 downto 0)  := "1000000";
    constant ONE_7SEG: std_logic_vector(6 downto 0)   := "1111001";
    constant TWO_7SEG: std_logic_vector(6 downto 0)   := "0100100";
    constant THREE_7SEG: std_logic_vector(6 downto 0) := "0110000";
    constant FOUR_7SEG: std_logic_vector(6 downto 0)  := "0011001";
    constant FIVE_7SEG: std_logic_vector(6 downto 0)  := "0010010";
    constant SIX_7SEG: std_logic_vector(6 downto 0)   := "0000010";
    constant SEVEN_7SEG: std_logic_vector(6 downto 0) := "1111000";
    constant EIGHT_7SEG: std_logic_vector(6 downto 0) := "0000000";
    constant NINE_7SEG: std_logic_vector(6 downto 0)  := "0011000";
    constant A_7SEG: std_logic_vector(6 downto 0)     := "0001000";
    constant B_7SEG: std_logic_vector(6 downto 0)     := "0000011";
    constant C_7SEG: std_logic_vector(6 downto 0)     := "1000110";
    constant D_7SEG: std_logic_vector(6 downto 0)     := "0100001";
    constant E_7SEG: std_logic_vector(6 downto 0)     := "0000110";
    constant F_7SEG: std_logic_vector(6 downto 0)     := "0001110";

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
			ledNum => ledNum
		);

    --============================================================================
    --  Convert 4-bit binary value into its equivalent 7-segment pattern
    --============================================================================
    BINARY_TO_7SEG: with ledNum select
        seg <= ZERO_7SEG  when "0000",
                     ONE_7SEG   when "0001",
                     TWO_7SEG   when "0010",
                     THREE_7SEG when "0011",
                     FOUR_7SEG  when "0100",
                     FIVE_7SEG  when "0101",
                     SIX_7SEG   when "0110",
                     SEVEN_7SEG when "0111",
                     EIGHT_7SEG when "1000",
                     NINE_7SEG  when "1001",
                     A_7SEG     when "1010",
                     B_7SEG     when "1011",
                     C_7SEG     when "1100",
                     D_7SEG     when "1101",
                     E_7SEG     when "1110",
                     F_7SEG     when others;

	dp <= not ACTIVE;
	an <= "1110";

end MovingLed_BASYS3_ARCH;
