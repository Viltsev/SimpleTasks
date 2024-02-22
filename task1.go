package main

import (
	"fmt"
	"math"
)

type Polynomial []float64

// input method
func inputPoly() Polynomial {
	var degree int
	fmt.Println("Enter degree of polynom: ")
	fmt.Scan(&degree)

	polynomial := make(Polynomial, degree+1)
	for i := degree; i >= 0; i-- {
		fmt.Printf("Enter the coeff for x^%d: ", i)
		fmt.Scan(&polynomial[i])
	}
	return polynomial
}

// output polynomial
func (p Polynomial) printPolynom() {
	degree := len(p) - 1
	for i := degree; i >= 0; i-- {
		if i == 0 {
			fmt.Printf("%.2f", p[i])
		} else if i == 1 {
			fmt.Printf("%.2fx + ", p[i])
		} else {
			fmt.Printf("%.2fx^%d + ", p[i], i)
		}
	}
	fmt.Println()
}

// polynomials adding
func addPolynomials(p1, p2 Polynomial) Polynomial {
	var result Polynomial
	len1, len2 := len(p1), len(p2)
	maxLen := len1
	if len2 > len1 {
		maxLen = len2
	}

	result = make(Polynomial, maxLen)
	for i := 0; i < maxLen; i++ {
		var term1, term2 float64
		if i < len1 {
			term1 = p1[i]
		}
		if i < len2 {
			term2 = p2[i]
		}
		result[i] = term1 + term2
	}

	return result
}

// polynomials subtracting
func subtractPolynomials(p1, p2 Polynomial) Polynomial {
	var result Polynomial
	len1, len2 := len(p1), len(p2)
	maxLen := len1
	if len2 > len1 {
		maxLen = len2
	}

	result = make(Polynomial, maxLen)
	for i := 0; i < maxLen; i++ {
		var term1, term2 float64
		if i < len1 {
			term1 = p1[i]
		}
		if i < len2 {
			term2 = p2[i]
		}
		result[i] = term1 - term2
	}

	return result
}

// polynomials multiply
func multiplyPolynomials(p1, p2 Polynomial) Polynomial {
	degree1, degree2 := len(p1)-1, len(p2)-1
	result := make(Polynomial, degree1+degree2+1)
	for i := 0; i <= degree1; i++ {
		for j := 0; j <= degree2; j++ {
			result[i+j] += p1[i] * p2[j]
		}
	}
	return result
}

// find derivative of polynomial
func derivative(p Polynomial) Polynomial {
	degree := len(p) - 1
	derivative := make(Polynomial, degree)
	for i := 0; i < degree; i++ {
		derivative[i] = p[i+1] * float64(i+1)
	}
	return derivative
}

// find the value of polynomial with x
func evaluatePolynomial(p Polynomial, x float64) float64 {
	result := 0.0
	for i, coef := range p {
		result += coef * pow(x, i)
	}
	return result
}

// pow method
func pow(x float64, n int) float64 {
	result := 1.0
	for i := 0; i < n; i++ {
		result *= x
	}
	return result
}

// indefinite integral method
func (p Polynomial) indefiniteIntegral() Polynomial {
	result := make(Polynomial, len(p)+1)
	for i := 0; i < len(p); i++ {
		result[i+1] = p[i] / float64(i+1)
	}
	return result
}

// definite integral method
func (p Polynomial) definiteIntegral(a, b float64) float64 {
	var integral float64
	for i := 0; i < len(p); i++ {
		integral += p[i] / float64(i+1) * (math.Pow(b, float64(i+1)) - math.Pow(a, float64(i+1)))
	}
	return integral
}

func main() {
	fmt.Println("Input the first polynomial: ")
	p1 := inputPoly()

	fmt.Println("Input the second polynomial: ")
	p2 := inputPoly()
	fmt.Println("--------------------------------")
	fmt.Println("The first polynomial: ")
	p1.printPolynom()

	fmt.Println("The second polynomial: ")
	p2.printPolynom()

	fmt.Println("--------------------------------")
	fmt.Println("Sum of polynomials:")
	addPolynomials(p1, p2).printPolynom()

	fmt.Println("--------------------------------")
	fmt.Println("Subtraction of polynomials:")
	subtractPolynomials(p1, p2).printPolynom()

	fmt.Println("--------------------------------")
	fmt.Println("Multiplication of polynomials:")
	multiplyPolynomials(p1, p2).printPolynom()

	fmt.Println("--------------------------------")
	fmt.Println("Derivative of the first polynomial:")
	derivative(p1).printPolynom()

	x := 2.0
	fmt.Printf("Value of the first polynomial by x = %.2f: %.2f\n", x, evaluatePolynomial(p1, x))

	fmt.Println("----------------------")
	fmt.Println("INTEGRALS")
	fmt.Println("----------------------")

	indefinite := p1.indefiniteIntegral()
	fmt.Println("Indefinite Integral of the first Polynomial:")
	indefinite.printPolynom()

	// interval a--b
	a, b := 0.0, 1.0
	definite := p1.definiteIntegral(a, b)
	fmt.Printf("Definite Integral of the first Polynomial from %.2f to %.2f: %.2f\n", a, b, definite)
}
