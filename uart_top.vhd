----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2024 02:30:49 PM
-- Design Name: 
-- Module Name: uart_top - Behavioral
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

entity uart_top is
  Port ( 
    TXD, clk      : in std_logic;
    btn           : in std_logic_vector(1 downto 0);
    CTS, RTS, RXD : out std_logic
  );
end uart_top;

architecture Behavioral of uart_top is

    component debouncer is
        port(
          btn  : in std_logic;
          clk  : in std_logic;
          dbnc : out std_logic := '0'
        );
    end component;

    component clock_div is
        port (
          clk : in std_logic;
          div : out std_logic
        );
    end component;

    component sender is
      port ( 
          rst, clk, nbl, btn, ready : in std_logic;
          send                      : out std_logic;
          char                      : out std_logic_vector (7 downto 0)
      );
    end component;
    
    component uart is
      port ( 
        clk, en, send, rx, rst      : in std_logic;
        charSend                    : in std_logic_vector (7 downto 0);
        ready, tx, newChar          : out std_logic;
        charRec                     : out std_logic_vector (7 downto 0)
      );
    end component;

    signal dbnc1, dbnc2, div, ready, send  : std_logic;
    signal charSend : std_logic_vector(7 downto 0);
    
begin

        U1: debouncer 
        port map (
            btn  => btn(0),
            clk  => clk,
            dbnc => dbnc1
        );
        
        U2: debouncer 
        port map (
            btn  => btn(1),
            clk  => clk,
            dbnc => dbnc2
        );
        
        U3: clock_div 
        port map(
            clk => clk,
            div => div
        );
        
        U4: sender
        port map(
            rst   => dbnc1,
            clk   => clk,
            nbl   => div,
            btn   => dbnc2,
            ready => ready,
            send  => send,
            char  => charSend
        );
        
        U5: uart 
        port map(
            clk => clk, 
            en => div, 
            send => send, 
            rx => TXD, 
            rst => dbnc1,
            charSend => charSend,
            ready => ready, 
            tx => RXD
        );

    CTS <= '0';
    RTS <= '0';

end Behavioral;
