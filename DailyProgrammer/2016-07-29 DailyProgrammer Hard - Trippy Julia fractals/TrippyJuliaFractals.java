package me.oskarmendel;

import java.awt.image.BufferedImage;
import java.awt.image.WritableRaster;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;

public class TrippyJuliaFractals {
	//Our Julia function: f(x) = z^2 (- 0.221 - 0.713) Were () is the constant.
	static final double REALNUM = -0.221;
	static final double IMNUM = -0.713;
	static final double MINRANGE = -1;
	static final double MAXRANGE = 1;
	static final int WIDTH = 1920; //Image Width
	static final int HEIGHT = 1080; //Image Height
	static final int THRESHOLD = 2; //
	static final int MAXITERATIONS = 128; //Max iterations per pixel determites the detail.
	
	static class ComplexNumber {
		double real;
		double imaginary;
		
		public ComplexNumber(double re, double im) {
			this.real = re;
			this.imaginary = im;
		}
		
		public void applyF(){
			double re = real*real - imaginary*imaginary + REALNUM;
			double im = 2*real*imaginary + IMNUM;
			this.real = re;
			this.imaginary = im;
		}
		
		public double getAbs() {
			return Math.sqrt(imaginary*imaginary + real*real);
		}
	}
	
	public static void main(String[] args) throws IOException {
		// TODO Auto-generated method stub
		long start = System.currentTimeMillis();
		
		BufferedImage image = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_BYTE_GRAY);
		WritableRaster wr = (WritableRaster) image.getData();
		
		int[] pixels;
		int x = 0;
		int y = 0;
		
		//Looping through each pixel making complex numbers for all spaces
		for (y = 0; y < HEIGHT; y++){
			for (x = 0; x < WIDTH; x++) {
				//Transforming the coordinates so it lies between the range -1 to 1
				double a = x*(MAXRANGE-MINRANGE) / WIDTH + MINRANGE;
				double b = y*(MAXRANGE-MINRANGE) / HEIGHT + MINRANGE;
				
				ComplexNumber cn = new ComplexNumber(a, b);
				
				//Num of iterations
				int i;
				
				//Starting iteration process
				for (i = 0; i < MAXITERATIONS; i++){
					cn.applyF();
					if(cn.getAbs()>THRESHOLD) {
						break;
					}
				}
				
				wr.setSample(x, y, 0, i);
			}
		}
		
		//Set the content of the raster to the image
		image.setData(wr);
		System.out.println("Image is done.");
		//Write the buffered image to a new file
		ImageIO.write(image, "png", new File("juliafractal.png"));
		
		long end = System.currentTimeMillis();
		System.out.println((end - start) + " ms");
	}
}