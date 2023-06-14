module test;
import std::io;
import std::math;
import std::collections::list;

struct Point2
{
	float x, y;
}

// Short function syntax
fn float Point2.at(Point2 this, int i) @operator([]) => i ? this.x : this.y;
fn int Point2.len(Point2 this) => 2;

macro bool is_float_vec($Type)
{
	var $temp = $Type{};
	$if $checks($temp[0]):
		$switch
			$case (@typekind($temp[0]) != FLOAT):
				return false;
			$case $checks($temp.len()):
				return values::@is_int($temp.len());
			$case $checks($temp.len):
				return values::@is_int($temp.len);
			$default:
				return false;
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
	var $Type = $typeof(vec[0]);
	// We have some types with `vec.len` and some with `vec.len()`
	$if $checks(vec.len()):
		var size = vec.len();
	$else
		var size = vec.len;
	$endif
	if (!size) return 0;
	$Type result = vec[0] * vec[0];
	for ($typeof(size) i = 1; i < size; i++)
	{
		result += vec[i] * vec[i];
	}
	return math::sqrt(result);
}

fn float norm2(float x, float y) => norm(Point2{x, y});

def DoubleList = List<double>;
def IntList = List<int>;

fn void main()
{
	io::printfn("hey: %s %s %s %s", is_float_vec(Point2), is_float_vec(int), is_float_vec(DoubleList), is_float_vec(IntList));
	io::printfn("norm: %s %s %s %s", norm2(3, 4), norm(double[2] { 3, 4 }), norm(double[] { 3, 4 }), norm(double[<2>] { 3, 4 }));
	DoubleList list;
	list.append(3);
	list.append(4);
	list.append(12);
	io::printfn("norm: %s", norm(list));
	void[] abc;
}
