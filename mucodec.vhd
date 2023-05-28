LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity mucodec is
    port (
        din     : IN std_logic_vector(2 downto 0);
        valid   : IN std_logic;
        clr     : IN std_logic;
        clk     : IN std_logic;
        dout    : OUT std_logic_vector(7 downto 0);
        dvalid  : OUT std_logic;
        error   : OUT std_logic);
end mucodec;

architecture Behavioral of mucodec is
    type state_type is (St_RESET, St_ERROR, 
                        St_1tx, St_1t1, St_1t2, St_1t3, St_1t4, St_1t5, St_1t6,
                        St_2tx, St_2t1, St_2t2, St_2t3, St_2t4, St_2t5, St_2t6, 
                        St_3tx, St_3t1, St_3t2, St_3t3, St_3t4, St_3t5, St_3t6,
                        St_4tx, St_4t1, St_4t2, St_4t3, St_4t4, St_4t5, St_4t6,
                        St_5tx, St_5t1, St_5t2, St_5t3, St_5t4, St_5t5, St_5t6,
                        St_6tx, St_6t1, St_6t2, St_6t3, St_6t4, St_6t5, St_6t6,
                        St_BOS1, St_BOS2, St_BOS3, St_BOS4, 
                        St_EOS1, St_EOS2, St_EOS3, St_EOS4);
    signal state, next_state : state_type := St_RESET;
	signal msg : std_logic_vector(7 downto 0);
	
    subtype byte is std_ulogic_vector(7 downto 0);
    function to_character(b: byte) return character is
    begin
        return character'val(to_integer(unsigned(b)));
    end function;
    
    -- Define additional signal needed here as needed
begin
    sync_process: process (clk, clr)
    begin
        if clr = '1' then
		       state <= St_RESET;
        elsif rising_edge(clk) then
               state <= next_state;
        end if;
    end process;

    state_logic: process (state,clk)
    begin
        -- Next State Logic
        -- Complete the following:
        
        next_state <= state;
 
        case(state) is
            when St_RESET =>
                
                if valid = '1' and din = "000" then
                		 next_state <= St_BOS1;
          		end if;

	          when St_BOS1 =>
                if (valid = '1' and din(2 downto 0) ="111") then
                		 next_state <= St_BOS2;
          		end if;
            when St_BOS2 =>
                if (valid = '1' and din(2 downto 0)="000") then
                		 next_state <= St_BOS3;

          			end if;
            when St_BOS3 =>
                if (valid = '1' and din(2 downto 0)="111") then
                		 next_state <= St_BOS4;
		
          			end if;
          
            when St_BOS4 =>
                if (valid = '1' and din(2 downto 0)="001") then          	
                		 next_state <= St_1tx; 
                elsif (valid = '1' and din(2 downto 0)="010") then
                		 next_state <= St_2tx;
                elsif (valid = '1' and din(2 downto 0)="011") then
                		 next_state <= St_3tx;  
                elsif (valid = '1' and din(2 downto 0)="100")then
                		 next_state <= St_4tx;  
                elsif (valid = '1' and din(2 downto 0)="101") then
                		 next_state <= St_5tx;   
              	elsif (valid = '1' and din(2 downto 0)="110") then
                		 next_state <= St_6tx;
                elsif (valid='1' and din(2 downto 0)="111") then
                  	 next_state <= St_EOS1;
          			end if;
                  
            when St_1tx =>
                if (valid = '1' and din(2 downto 0)="001") then     
                		 next_state <= St_1t1;   
                elsif (valid = '1' and din(2 downto 0)="010") then
                		 next_state <= St_1t2;
                elsif (valid = '1' and din(2 downto 0)="011") then
                		 next_state <= St_1t3;  
                elsif (valid = '1' and din(2 downto 0)="100") then
                		 next_state <= St_1t4;
                elsif (valid = '1' and din(2 downto 0)="101") then
                		 next_state <= St_1t5;
                elsif (valid = '1' and din(2 downto 0)="110") then						--END 1tx
                		 next_state <= St_1t6;
          			end if;
          
          
          
            when St_2tx =>
                if (valid = '1' and din(2 downto 0)="001") then
                		 next_state <= St_2t1;
                elsif (valid = '1' and din(2 downto 0)="010") then
                		 next_state <= St_2t2;
                elsif (valid = '1' and din(2 downto 0)="011") then
                		 next_state <= St_2t3;  
                elsif (valid = '1' and din(2 downto 0)="100") then
                		 next_state <= St_2t4;
                elsif (valid = '1' and din(2 downto 0)="101") then
                		 next_state <= St_2t5;
                elsif (valid = '1' and din(2 downto 0)="110") then						--END 2tx
                		 next_state <= St_2t6; 
          			end if;
          

            when St_3tx =>
                if (valid = '1' and din(2 downto 0)="001") then
                		 next_state <= St_3t1;
                elsif (valid = '1' and din(2 downto 0)="010") then
                		 next_state <= St_3t2;
                elsif (valid = '1' and din(2 downto 0)="011") then
                		 next_state <= St_3t3; 
                elsif (valid = '1' and din(2 downto 0)="100") then
                		 next_state <= St_3t4;
                elsif (valid = '1' and din(2 downto 0)="101") then
                		 next_state <= St_3t5;
                elsif (valid = '1' and din(2 downto 0)="110") then						--END 3tx
                		 next_state <= St_3t6;    
          			end if;


            when St_4tx =>
                if (valid = '1' and din(2 downto 0)="001") then
                		 next_state <= St_4t1;
                elsif (valid = '1' and din(2 downto 0)="010") then
                		 next_state <= St_4t2;
                elsif (valid = '1' and din(2 downto 0)="011") then
                		 next_state <= St_4t3; 
                elsif (valid = '1' and din(2 downto 0)="100") then
                		 next_state <= St_4t4;
                elsif (valid = '1' and din(2 downto 0)="101") then
                		 next_state <= St_4t5;
                elsif (valid = '1' and din(2 downto 0)="110") then						--END 4tx
                		 next_state <= St_4t6;     
          			end if;
          
    
            when St_5tx =>
                if (valid = '1' and din(2 downto 0)="001") then
                		 next_state <= St_5t1;
                elsif (valid = '1' and din(2 downto 0)="010") then
                		 next_state <= St_5t2;
                elsif (valid = '1' and din(2 downto 0)="011") then
                		 next_state <= St_5t3;
                elsif (valid = '1' and din(2 downto 0)="100") then
                		 next_state <= St_5t4;
                elsif (valid = '1' and din(2 downto 0)="101") then
                		 next_state <= St_5t5;
                elsif (valid = '1' and din(2 downto 0)="110") then						--END 5tx
                		 next_state <= St_5t6; 
                end if;
           
          
            when St_6tx =>
                if (valid = '1' and din(2 downto 0)="001") then
                		 next_state <= St_6t1;
                elsif (valid = '1' and din(2 downto 0)="010") then
                		 next_state <= St_6t2;
                elsif (valid = '1' and din(2 downto 0)="011") then
                		 next_state <= St_6t3; 
                elsif (valid = '1' and din(2 downto 0)="100") then
                		 next_state <= St_6t4;
                elsif (valid = '1' and din(2 downto 0)="101") then
                		 next_state <= St_6t5;
                elsif (valid = '1' and din(2 downto 0)="110") then						--END 6tx
                		 next_state <= St_6t6;        
								end if;
                  
          when St_1t1 =>
                  	next_state <= St_BOS4;
          when St_1t2 =>
                  	next_state <= St_BOS4;
          when St_1t3 =>
                  	next_state <= St_BOS4;
          when St_1t4 =>
                  	next_state <= St_BOS4;
          when St_1t5 =>
                 	next_state <= St_BOS4;
          when St_1t6 =>
                  	next_state <= St_BOS4;
          when St_2t1 =>
                  	next_state <= St_BOS4;
          when St_2t2 =>
                  	next_state <= St_BOS4;
          when St_2t3 =>
                  	next_state <= St_BOS4;
          when St_2t4 =>
                  	next_state <= St_BOS4;
          when St_2t5 =>
                  	next_state <= St_BOS4;
          when St_2t6 =>
                  	next_state <= St_BOS4;
          when St_3t1 =>
                  	next_state <= St_BOS4;
          when St_3t2 =>
                  	next_state <= St_BOS4;
          when St_3t3 =>
                  	next_state <= St_BOS4;
          when St_3t4 =>
                  	next_state <= St_BOS4;
          when St_3t5 =>
                  	next_state <= St_BOS4;
          when St_3t6 =>
                  	next_state <= St_BOS4;
          when St_4t1 =>
                  	next_state <= St_BOS4;
          when St_4t2 =>
                  	next_state <= St_BOS4;
          when St_4t3 =>
                  	next_state <= St_BOS4;
          when St_4t4 =>
                  	next_state <= St_BOS4;
          when St_4t5 =>
                  	next_state <= St_BOS4;
          when St_4t6 =>
                  	next_state <= St_BOS4;
          when St_5t1 =>
                  	next_state <= St_BOS4;
          when St_5t2 =>
                  	next_state <= St_BOS4;
          when St_5t3 =>
                  	next_state <= St_BOS4;
          when St_5t4 =>
                  	next_state <= St_BOS4;
          when St_5t5 =>
                  	next_state <= St_BOS4;
          when St_5t6 =>
                  	next_state <= St_BOS4;
          when St_6t1 =>
                  	next_state <= St_BOS4;           
          when St_6t2 =>
                  	next_state <= St_BOS4;
          when St_6t3 =>
                  	next_state <= St_BOS4;
          when St_6t4 =>
                  	next_state <= St_BOS4;
          when St_6t5 =>
                  	next_state <= St_BOS4;               
          when St_6t6 =>
                  	next_state <= St_BOS4;           
                  
	          when St_EOS1 =>
                if (valid = '1' and din(2 downto 0)="000") then
                		 next_state <= St_EOS2;
          			end if;
            when St_EOS2 =>
                if (valid = '1' and din(2 downto 0)="111") then
                		 next_state <= St_EOS3;
          			end if;
            when St_EOS3 =>
                if (valid = '1' and din(2 downto 0)="000") then
                		 next_state <= St_EOS4;		
          			end if;
            when St_EOS4 =>
                		 next_state <= St_RESET;
            when St_ERROR =>
                    next_state <= St_RESET;


				end case;
    end process;

    output_logic: process (state, msg)
    begin
        case(state) is 
      			when St_1t1 =>									--1t
          			dvalid <= '0'; 
      			when St_1t2 =>
          			dout <= "01000001"; --A
      			when St_1t3 =>
          			dout <= "01000010"; --B
      			when St_1t4 =>
          			dout <= "01000011"; --C
      			when St_1t5 =>
          			dout <= "01000100"; --D
      			when St_1t6 =>
          			dout <= "01000101"; --E				
	
      			when St_2t1 =>									--2t
          			dout <= "01000110"; --F
      			when St_2t2 =>
          			dvalid <= '0';  
      			when St_2t3 =>
          			dout <= "01000111"; --G
      			when St_2t4 =>
          			dout <= "01001000"; --H
      			when St_2t5 =>
          			dout <= "01001001"; --I
      			when St_2t6 =>
          			dout <= "01001010"; --J

      			when St_3t1 =>									--3t
          			dout <= "01001011"; --K
      			when St_3t2 =>
          			dout <= "01001100";  --L01001100
      			when St_3t3 =>
          			dvalid <= '0'; 
      			when St_3t4 =>
          			dout <= "01001101"; --M
      			when St_3t5 =>
          			dout <= "01001111";  --N
      			when St_3t6 =>
          			dout <= "01010000"; --O

      			when St_4t1 =>									--4t
          			dout <= "01010001"; --P
      			when St_4t2 =>
          			dout <= "01010010";  --Q
      			when St_4t3 =>
          			dout <= "01010011"; --R
      			when St_4t4 =>
          			dvalid <= '0'; 
      			when St_4t5 =>
          			dout <= "01010011";  
      			when St_4t6 =>
          			dout <= "01010100"; 

      			when St_5t1 =>									--5t
          			dout <= "01010101"; 
      			when St_5t2 =>
          			dout <= "01010110";  
      			when St_5t3 =>
          			dout <= "01010111"; 
      			when St_5t4 =>
          			dout <= "01011000"; 
      			when St_5t5 =>
          			dvalid <= '0';  
      			when St_5t6 =>
          			dout <= "01011001"; 

      			when St_6t1 =>									--6t
          			dout <= "01011010"; --Z
      			when St_6t2 =>
          			dout <= "00100001";  --!
      			when St_6t3 =>
          			dout <= "00101110"; --.
      			when St_6t4 =>
          			dout <= "00111111"; --?
      			when St_6t5 =>
          			dout <= "00100000"; --" "
      			when St_6t6 =>
          			dvalid <= '0';
                 when St_BOS1 =>
      					dvalid <= '1'; 					
				when St_ERROR =>
          			error <= '1'; 

            when others => null;
                  
  		end case;
    end process;
      
end Behavioral;