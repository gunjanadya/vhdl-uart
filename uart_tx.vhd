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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

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
signal PS : state_type := start;
signal data_count : std_logic_vector(3 downto 0) := (others => '0');
signal inshift : std_logic_vector(7 downto 0) := char;


begin

    process (clk)
    begin
    
        if (rst = '1') then
            PS <= idle;
            tx <= '1';
            ready <= '1';
            data_count <= (others => '0');
            
        elsif rising_edge(clk) AND en = '1' then
            case PS is 
            
                when data => 
                    if unsigned (data_count) < 8 then
                        tx <= inshift(to_integer(unsigned (data_count)));
                        PS <= data;
                        data_count <= std_logic_vector(unsigned(data_count) + 1);
                    else
                        tx <= '1';
                        data_count <= (others => '0');
                        PS <= idle;
                    end if;
                        
                when idle => 
                    ready <= '1';
                    tx <= '1';
                    data_count <= (others => '0');
                    
                    if(send = '1') then 
                        PS <= start;
                        inshift <= char;
    
                        else
                        PS <= idle;
                    end if;
                    
                when start => 
                    tx <= '0';
                    ready <= '0';
                    PS <= data;

                when others =>
                    PS <= idle;
            end case;
        end if;
    end process;

end Behavioral;
