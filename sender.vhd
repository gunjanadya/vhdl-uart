----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2024 09:49:04 PM
-- Design Name: 
-- Module Name: sender - Behavioral
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

entity sender is
  Port ( 
      rst, clk, nbl, btn, ready : in std_logic;
      send                      : out std_logic;
      char                      : out std_logic_vector (7 downto 0)
  );
end sender;

architecture Behavioral of sender is

type str is array (0 to 4) of std_logic_vector(7 downto 0);
type state_type is (idle, busyA, busyB, busyC);

signal netid   : str := (x"103", x"97", x"52", x"48", x"50");
signal i       : std_logic_vector(3 downto 0):= (others => '0');
signal PS      : state_type := idle;
signal inshift : std_logic_vector(7 downto 0) := (others => '0');

begin

    process (clk)
    begin
            
        if rising_edge(clk) AND nbl = '1' then
        
            if (rst = '1') then
                send <= '0';
                char <= (others => '0');
                i    <= (others => '0');
                PS   <= idle;
            end if;
            case PS is 
                when idle => 
                    if(ready = '1' and btn = '1') then
                        if unsigned (i) < 5 then
                            send <= '1';
                            char <= netid(unsigned(i));
                            i    <= std_logic_vector((unsigned)i+1);
                        else
                            i <= (others => '0');
                        end if;
                    end if;
                when busyA => 
                    PS <= busyB;
                when busyB => 
                    send <= '0';
                    PS   <= busyC;
                when busyC => 
                    if(ready = '1' and btn = '0') then
                        PS <= idle;
                    end if;
                when others =>
                    PS <= idle;
            end case;
        end if;
    end process;


end Behavioral;
