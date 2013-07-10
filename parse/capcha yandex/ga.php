<?php

// (c) 2009 P_r_i_m_a_t

class GA
{
	protected $population;
	protected $count;
	protected $low;
	protected $high;
	protected $length;
	protected $fitness_function;
		
	function __construct($count, $ff, $low, $high, $length)
	{
		$this->count = $count;
		$this->fitness_function = $ff;
		$this->low = $low;
		$this->high = $high;
		$this->length = $length;	
	}
	
	public function run($timeout, $min)
	{
		$this->population = array();
		for ($i = 0; $i < $this->count; $i++)
		{
			$params = array('w' => rand(4, 16), 'h' => rand(5, 10), 'a' => rand(-30, 30), 's' => rand($this->low + 2, $this->high - 2), 'o' => rand(0, 40));			
			$this->population []= array('fitness' => 0, 'dna' => $params);			
		}	
		
		$generation = 0;
		$best_fitness = false;
		$best_dna = false;	

		while ($generation <= $timeout)
		{
			$total_fitness = 0;
			foreach ($this->population as $key => $val)
			{
				$this->population[$key]['fitness'] = $this->fitness($val['dna']);
				if ($this->population[$key]['fitness'] > $best_fitness || $best_fitness === false)
				{
					$best_fitness = $this->population[$key]['fitness'];
					$best_dna = $val['dna'];						
				}
				$total_fitness += $this->population[$key]['fitness'];
			}
			
			if ($best_fitness >= $min)
				break;
				
			$temp_population = array();
			$temp_population []= array('fitness' => 0, 'dna' => $best_dna);			

			for ($i = 1; $i < $this->count; $i++)
			{
				if (rand(0, 4) != 0)
      			{
        			$r = rand(0, $total_fitness - 1);        			
        			$s = $this->population[$t]['fitness'];
        			$t = 0;
        			while ($s < $r && $t < $this->count - 1) { $t++; $s += $this->population[$t]['fitness']; }
      				$temp_population []= array('fitness' => 0, 'dna' => $this->mutation($this->population[$t]['dna']));
      			}
      			else
      			{
					$params = array('fitness' => 0, 'dna' => array('w' => rand(4, 16), 'h' => rand(5, 10), 'a' => rand(-30, 30), 's' => rand($this->low + 2, $this->high - 2), 'o' => rand(0, 40)));
      				$temp_population []= $params;
      			}
			}
			$this->population = $temp_population;
			$generation++;   
		}	
		return array('best_dna' => $best_dna, 'best_fitness' => $best_fitness);
	}
	
	protected function fitness($x)
	{
		return $this->fitness_function->test_dna($x);		
	}
	
	protected function mutation($x)
	{
		switch (rand(1, 5))
		{
			case 1:
				$x['w'] += rand(-2, 2);
			case 2:
				$x['h'] += rand(-2, 2);
			case 3: 
				$x['a'] += rand(-5, 5);
			case 4:
				$x['s'] += rand(-3, 3);
			case 5:
				$x['o'] += rand(-3, 3);
		}		
		return $x;		
	}	
}

?>
