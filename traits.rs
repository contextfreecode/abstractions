use std::ops::*;

trait Float: Copy + Sized + Add<Self, Output = Self> + Mul<Self, Output = Self> {
    fn sqrt(self) -> Self;

    fn zero() -> Self;
}

impl Float for f32 {
    fn sqrt(self) -> f32 {
        self.sqrt()
    }

    fn zero() -> f32 {
        0f32
    }
}

trait FloatVec<Scalar: Float>: Index<usize, Output = Scalar> {
    fn len(&self) -> usize;
}

struct Point2 {
    x: f32,
    y: f32,
}

impl Index<usize> for Point2 {
    type Output = f32;

    fn index(&self, i: usize) -> &f32 {
        if i == 0 {
            &self.x
        } else {
            &self.y
        }
    }
}

impl FloatVec<f32> for Point2 {
    fn len(&self) -> usize {
        2
    }
}

fn norm<Scalar: Float, Vec: FloatVec<Scalar>>(vec: &Vec) -> Scalar {
    // Check empty first to avoid adding 0 and achieve zero cost.
    if vec.len() == 0 {
        return Scalar::zero();
    }
    // Non-empty case.
    let mut result = vec[0] * vec[0];
    for i in 1..vec.len() {
        result = result + vec[i] * vec[i];
    }
    result.sqrt()
}

pub fn norm2(x: f32, y: f32) -> f32 {
    // return (x * x + y * y).sqrt();
    return norm(&Point2 { x, y });
}

impl<Scalar: Float> FloatVec<Scalar> for Vec<Scalar> {
    fn len(&self) -> usize {
        return self.len();
    }
}

fn main() {
    println!("norm: {}", norm(&vec![1.0, 2.0, 3.0]));
    println!("norm: {}", norm2(3f32, 4f32));
}
