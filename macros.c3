module test;
import std::io;
import std::math;

// This roughly follows the Zig implementation.

struct Point2
{
	float x, y;
}

// Short function syntax
fn float Point2.at(Point2 this, int i) @operator([]) => i ? this.x : this.y;
fn int Point2.len(Point2 this) => 2;

macro bool is_float_vec($Type)
{
	$if $checks($Type{}[0]) || $checks($Type{}.len()):
		$switch
			$case $Type.kindof != STRUCT: return false;
			$case @typekind($Type{}[0]) != FLOAT: return false;
			$case !values::@is_int($Type{}.len()): return false;
			$default: return true;
		$endswitch
	$else
		return false;
	$endif
}

// Use contracts rather than asserts:

/**
 * @require is_float_vec($typeof(vec))
 **/
macro norm(vec)
{
	var $IndexType = $typeof(vec.len());
	$IndexType size = vec.len();
	if (!size) return 0;
	var $Type = $typeof(vec.at(0));
	$Type result = vec[0] * vec[0];
	for ($IndexType i = 1; i < size; i++)
	{
		result += vec[i] * vec[i];
	}
	return math::sqrt(result);
}

fn float norm2(float x, float y) => norm(Point2{x, y});

fn void main()
{
	io::printfn("hey: %s %s", is_float_vec(Point2), is_float_vec(int));
	io::printfn("norm: %s", norm2(3, 4));
}
