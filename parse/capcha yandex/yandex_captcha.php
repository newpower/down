<?php

// (c) 2009 P_r_i_m_a_t

class Yandex_CAPTCHA
{
	protected $image;
	protected $width;
	protected $height;
	protected $bg_color;
	protected $mask;
	protected $digits_quantity;
	protected $digits;
	protected $patterns; 
	protected $ann;

	function __construct($filename, $ann_file, $digits_quantity)
	{
		$this->image = imagecreatefromgif($filename);
		$size = getimagesize($filename);
		$this->width = $size[0];
		$this->height = $size[1];
		$this->bg_color = imagecolorat($this->image, 0, 0);
		$this->update_mask();
		$this->digits_quantity = $digits_quantity;		
		$this->ann = fann_create($ann_file);		
	}	
	
	protected function update_mask()
	{
		$this->mask = array();
		for ($i = 0; $i < $this->width; $i++)
		{
			for ($j = 0; $j < $this->height; $j++)
			{
				$this->mask[$i][$j] = $this->colordist(imagecolorat($this->image, $i, $j), $this->bg_color) > 30 ? 1 : 0;			
			}
		}
	}

	protected function colordist($color1, $color2)
	{
		return sqrt(pow((($color1 >> 16) & 0xFF) - (($color2 >> 16) & 0xFF), 2) + 
					pow((($color1 >> 8) & 0xFF) - (($color2 >> 8) & 0xFF), 2) + 
					pow(($color1 & 0xFF) - ($color2 & 0xFF), 2));
	}	
	
	protected function get_brightness($color)
	{
		return ((($color >> 16) & 0xFF) + (($color >> 8) & 0xFF) + ($color & 0xFF)) / 765;
	}	
		
	protected function remove_logo()
	{
		imagefilledrectangle($this->image, $this->width - 37, 0, $this->width - 1, 14, $this->bg_color);		
	}
	
	protected function crop($min_left, $min_right, $min_top, $min_bottom)
	{
		$top_border = 0;	
		while ($top_border < $this->height - 1)
		{
			$count = 0;
			for ($i = 0; $i < $this->width; $i++)
			{
				if ($this->colordist(imagecolorat($this->image, $i, $top_border), $this->bg_color) > 10)
					$count++;		
			}
			if ($count > $min_top)
				break;
			$top_border++;		
		}
	
		$bottom_border = $this->height - 1;	
		while ($bottom_border > 0)
		{
			$count = 0;
			for ($i = 0; $i < $this->width; $i++)
			{
				if ($this->colordist(imagecolorat($this->image, $i, $bottom_border), $this->bg_color) > 10)
					$count++;		
			}
			if ($count > $min_bottom)
				break;
			$bottom_border--;		
		}
	
		$left_border = 0;	
		while ($left_border < $this->width - 1)
		{
			$count = 0;
			for ($j = 0; $j < $this->height; $j++)
			{
				if ($this->colordist(imagecolorat($this->image, $left_border, $j), $this->bg_color) > 10)
					$count++;		
			}
			if ($count > $min_left)
				break;
			$left_border++;		
		}	
	
		$right_border = $this->width - 1;	
		while ($right_border > 0)
		{
			$count = 0;
			for ($j = 0; $j < $this->height; $j++)
			{
				if ($this->colordist(imagecolorat($this->image, $right_border, $j), $this->bg_color) > 10)
					$count++;		
			}
			if ($count > $min_right)
				break;
			$right_border--;		
		}
			
		$this->width = $right_border - $left_border + 1;
		$this->height = $bottom_border - $top_border + 1;
		$cropped_image = imagecreatetruecolor($this->width, $this->height); 
		imagecopy($cropped_image, $this->image, 0, 0, $left_border, $top_border, $this->width, $this->height);
		imagedestroy($this->image);
		$this->image = $cropped_image;
		$this->bg_color = imagecolorat($this->image, 0, 0);
		$this->update_mask();
	}
	
	public function test_dna($array)
	{
		$fitness = 0;
		$points = 0;
		for ($i = 0; $i < $this->width; $i++)
		{
			$y = $array['s'] + floor($array['h'] * sin(($i + $array['o']) / max(1, $array['w'])) + $array['a'] * ($i / $this->width));
			if ($y < 0 || $y >= $this->height)
				return 0;		
			if ($this->mask[$i][$y])
				$points += 5;				
			elseif ($y - 1 >= 0 && $this->mask[$i][$y - 1])
				$points += 2;
			elseif ($y + 1 < $this->height && $this->mask[$i][$y + 1])
				$points += 2;
			else
				$points = 0;
			if ($i % 3 == 0)
			{
				$fitness += $points;
				$points = 0;				
			}	
				
		}	
		return $fitness;
	} 
	
	protected function remove_line($array)
	{
		for ($i = 0; $i < $this->width; $i++)
		{
			$y = $array['s'] + floor($array['h'] * sin(($i + $array['o']) / max(1, $array['w'])) + $array['a'] * ($i / $this->width));
			if ($y < 0 || $y >= $this->height)
				continue;			
			imagesetpixel($this->image, $i, $y - 1, $this->bg_color);
			imagesetpixel($this->image, $i, $y, $this->bg_color);
			imagesetpixel($this->image, $i, $y + 1, $this->bg_color);
		}		
	}
	
	protected function divide_digits()
	{
		$this->digits = array();
		$digit_width = ceil($this->width / $this->digits_quantity); 
		for ($i = 0; $i < $this->digits_quantity; $i++)
		{
			$offset = floor($i * ($this->width / $this->digits_quantity));
			$offset = min($offset, $this->width - $digit_width);
			$top_border = 0;	
			while ($top_border < $this->height - 1)
			{
				$count = 0;
				for ($j = $offset; $j < $offset + $digit_width; $j++)
				{
					if ($this->colordist(imagecolorat($this->image, $j, $top_border), $this->bg_color) > 30)
						$count++;		
				}
				if ($count > 3)
					break;
				$top_border++;		
			}
			$bottom_border = $this->height - 1;	
			while ($bottom_border > 0)
			{
				$count = 0;
				for ($j = $offset; $j < $offset + $digit_width; $j++)
				{
					if ($this->colordist(imagecolorat($this->image, $j, $bottom_border), $bg_color) > 30)
						$count++;		
				}
				if ($count > 3)
					break;
				$bottom_border--;		
			}
			$this->digits[$i]['image'] = imagecreatetruecolor($digit_width, $bottom_border - $top_border + 1);
			$this->digits[$i]['width'] = $digit_width;
			$this->digits[$i]['height'] = $bottom_border - $top_border + 1;
			imagecopy($this->digits[$i]['image'], $this->image, 0, 0, $offset, $top_border, $this->digits[$i]['width'], $this->digits[$i]['height']);		
		}
	}
	
	protected function recognize_digit($digit)
	{
		$temp_width = 20;
		$temp_height = 30;
		$temp_image = imagecreatetruecolor($temp_width, $temp_height);
		imagecopyresampled($temp_image, $this->digits[$digit]['image'], 0, 0, 0, 0, $temp_width, $temp_height, $this->digits[$digit]['width'], $this->digits[$digit]['height']);
		$sample = array();						
		for ($i = 0; $i < $temp_width; $i++)
		{
			for ($j = 0; $j < $temp_height; $j++)
			{							
				$sample []= $this->get_brightness(imagecolorat($temp_image, $i, $j)); 						
			}		
		}
		imagedestroy($temp_image);

		global $answer;
		global $set;
		$out = array_fill(0, 10, 0);
		$out[((int) substr($answer, $digit, 1))] = 1;
		$set []= array($sample, $out);
		
		$output = fann_run($this->ann, $sample);
		
		$max = 0;
		$best_match = 0;
		foreach ($output as $key => $val)
		{
			if ($val > $max)
			{
				$best_match = $key;
				$max = $val;				
			}			
		}
		if ($max == 0)
			$best_match = rand(0, 9);			

		return $best_match;		
	}
	
	public function parse()
	{
		$this->remove_logo();

		$this->crop(2, 2, 2, 2);

		$ga = new GA(100, $this, 0, $this->height - 1, $this->width);	
		$result = $ga->run(100, floor($this->width * 5 * 0.9));
		$this->remove_line($result['best_dna']);
		$this->update_mask();
		$ga = new GA(100, $this, 0, $this->height - 1, $this->width);	
		$result = $ga->run(100, floor($this->width * 5 * 0.9));
		$this->remove_line($result['best_dna']);		

		$this->crop(5, 8, 5, 5);

		$this->divide_digits();
			
		$result = '';
		for ($i = 0; $i < $this->digits_quantity; $i++)
		{		
			$result .= $this->recognize_digit($i);
		}
				
		return $result;		
	}
	
	public function show($digit = false)
	{
		header('Content-type: image/gif');
		if ($digit === false)
			imagegif($this->image);
		else			
			imagegif($this->digits[$digit]['image']);
		exit();			
	}
}

?>
