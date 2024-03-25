----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2024 04:45:41 PM
-- Design Name: 
-- Module Name: uart_top_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_top_tb is
--  Port ( );
end uart_top_tb;

architecture Behavioral of uart_top_tb is

component uart_top
  Port ( 
    TXD, clk      : in  std_logic;
    btn           : in  std_logic_vector(1 downto 0);
    CTS, RTS, RXD : out std_logic
  );
end component;

signal TXD, clk, CTS, RTS, RXD : std_logic                    := '0';
signal btn                     : std_logic_vector(1 downto 0) := "00";

begin
    dut: uart_top port map (
        TXD => TXD,
        clk => clk,
        btn => btn,
        CTS => CTS,
        RTS => RTS,
        RXD => RXD
    );
    -- clock process @125 MHz
    process begin
        clk <= '0';
        wait for 4 ns;
        clk <= '1';
        wait for 4 ns;
    end process;

    -- en process @ 125 MHz / 1085 = ~115200 Hz
    process begin
        btn(1) <= '0';
        wait for 50 ms;
        btn(1) <= '1';
        wait for 50 ms;
    end process;
    
    process begin
        btn(0) <= '0';
        wait for 100 ms;
        btn(0) <= '1';
        wait for 100 ms;
    end process;
    
end Behavioral;
