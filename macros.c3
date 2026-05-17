module test;
import std::io, std::math, std::collections::list;

struct Point2
{
	float x, y;
}

// Short function syntax
fn float Point2.at(Point2 this, int i) @operator([]) => i ? this.x : this.y;
fn int Point2.len(Point2 this) @operator(len) => 2;

macro bool is_float_vec($Type)
{
	$Type $temp = {};
	return $defined(lengthof($temp), $temp[0]) &&& @kindof($temp[0]) == FLOAT;
}

// Use contracts rather than asserts:

<*
 @require is_float_vec($Typeof(vec))
*>
macro norm(vec)
{
	var $Type = $Typeof(vec[0]);
	var size = lengthof(vec);
	if (!size) return ($Type)0;
	$Type result = vec[0] * vec[0];
	for ($Typeof(size) i = 1; i < size; i++)
	{
		result += vec[i] * vec[i];
	}
	return math::sqrt(result);
}

fn float norm2(float x, float y) => norm((Point2){x, y});

alias DoubleList = List{double};
alias IntList = List{int};

fn void main()
{
	io::printfn("hey: %s %s %s %s", is_float_vec(Point2), is_float_vec(int), is_float_vec(DoubleList), is_float_vec(IntList));
	io::printfn("norm: %s %s %s %s", norm2(3, 4), norm((double[2]){ 3, 4 }), norm((double[]){ 3, 4 }), norm((double[<2>]){ 3, 4 }));
	DoubleList list;
	list.push(3);
	list.push(4);
	list.push(12);
	io::printfn("norm: %s", norm(list));
}
