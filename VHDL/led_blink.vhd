-- vhdl file para hacer un contador  para hacer destellar el led 
-- Led D4 @ Pin 7
-- Led D5 @ Pin 9


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity led_blinker is
  port (
		clock_in : in  std_logic;
		out_5hz  : out std_logic;
		out_1hz  : out std_logic
		);
end led_blinker;
 
 
architecture Arquitectura of led_blinker is
 
-- constantes para las frecuencias que queremos en el led 
-- partiendo de un clock de 50Mhz
  constant constante_5HZ  : natural := 10000000;
  constant constante_1HZ  : natural := 50000000;
 
 
  -- estas signals seran los contadores:
  signal contador_5HZ  : natural range 0 to constante_5HZ;
  signal contador_1HZ  : natural range 0 to constante_1HZ;
   
  -- estas signals seran las que togglean a la frecuencia dada:
  signal bit_toggle_5HZ  : std_logic := '0';
  signal bit_toggle_1HZ   : std_logic := '0';
 
   
begin
 
-- procesos que corren a distintas frecuencias, todos concurrentes

  proceso_5HZ : process (clock_in) is
  begin
    if rising_edge(clock_in) then
      if contador_5HZ = constante_5HZ - 1 then  -- -1, since counter starts at 0
        bit_toggle_5HZ <= not bit_toggle_5HZ;
        contador_5HZ    <= 0;
      else
        contador_5HZ <= contador_5HZ + 1;
      end if;
    end if;
  end process proceso_5HZ;
 
   
  proceso_1HZ : process (clock_in) is
  begin
    if rising_edge(clock_in) then
      if contador_1HZ = constante_1HZ - 1 then  -- -1, since counter starts at 0
        bit_toggle_1HZ <= not bit_toggle_1HZ;
        contador_1HZ    <= 0;
      else
        contador_1HZ <= contador_1HZ + 1;
      end if;
    end if;
  end process proceso_1HZ;
 
   
out_1hz <= bit_toggle_1HZ;
out_5hz <= bit_toggle_5HZ;
 
end Arquitectura;

