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
    generic (CHAIN_SIZE: positive);
    port (
        reset:        in  std_logic;
        clock:        in  std_logic;
        button:       in  std_logic;
        syncedButton: out std_logic
    );
end ButtonSync;

architecture ButtonSync_ARCH of ButtonSync is
    constant ACTIVE:  std_logic := '1';
    signal buttonSyncChain: std_logic_vector(CHAIN_SIZE-1 downto 0);
begin
    process(reset, clock)
    begin
        if (reset=ACTIVE) then
            buttonSyncChain <= (others => '0');
        elsif rising_edge(clock) then
            buttonSyncChain <= buttonSyncChain(buttonSyncChain'high-1 downto 0) & button;
        end if;
    end process;

    syncedButton <= buttonSyncChain(buttonSyncChain'high);
end ButtonSync_ARCH;
