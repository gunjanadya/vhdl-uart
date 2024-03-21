----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2024 05:47:41 PM
-- Design Name: 
-- Module Name: uart_tx - Behavioral
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

entity uart_tx is
  Port ( 
      clk, en, send, rst : in std_logic;
      char               : in std_logic_vector(7 downto 0);
      ready, tx          : out std_logic
  );
end uart_tx;

architecture Behavioral of uart_tx is

type state_type is (data, idle, start);
signal PS, NS : state_type;
signal maj, newChar : std_logic := '0';
signal data_count : std_logic_vector(7 downto 0);

begin

    process (clk)
    begin
        if (rst = '1') then
            state_sig <= idle;
            tx <= '0';
            ready <= '1';
        elsif rising_edge(clk) then
        
        end if;
    end process;
    
    comb_process: process(PS, X1, X2)
    begin
        case PS is 
            when data => 
                if ((unsigned data_count) < 7) then
                    NS <= data;
                else if (maj XNOR newChar)
                    NS <= idle;
                end if;
            when idle => 
                if (maj = '0') then 
                    NS <= idle; 
                else
                    NS <= start;
                end if;
            when start => 
                NS <= data;
            when others =>
                NS <= ST2;
                Z <= '0';
        end case;
        end process comb_process;
    

end Behavioral;
