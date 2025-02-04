package shaders;
import openfl.display.Shader;
import openfl.utils.ByteArray;
class GraphicsShader extends Shader
{
	@:glVertexHeader(
		"attribute float triangle_Alpha;
		attribute vec4 triangle_ColorMultiplier;
		attribute vec4 triangle_ColorOffset;
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		
		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;
		
		uniform mat4 openfl_Matrix;
		uniform bool triangle_HasColorTransform;
		uniform vec2 openfl_TextureSize;")
	@:glVertexBody(
		"openfl_Alphav = triangle_Alpha;
		openfl_TextureCoordv = openfl_TextureCoord;
		
		if (triangle_HasColorTransform) {
			
			openfl_ColorMultiplierv = triangle_ColorMultiplier;
			openfl_ColorOffsetv = triangle_ColorOffset / 255.0;
			
		}
		
		gl_Position = openfl_Matrix * openfl_Position; ")
		
	@:glVertexSource("#pragma header
		
		void main(void) {
			
			#pragma body
			
		}")
	@:glFragmentHeader("
		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;
		
		uniform bool triangle_HasColorTransform;
		uniform vec2 openfl_TextureSize;
		uniform sampler2D bitmap; ")
		
	@:glFragmentBody(
		"vec4 color = texture2D (bitmap, openfl_TextureCoordv);
		
		if (color.a == 0.0) {
			
			gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
			
		} else if (triangle_HasColorTransform) {
			
			color = vec4 (color.rgb / color.a, color.a);
			
			mat4 colorMultiplier = mat4 (0);
			colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
			colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
			colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
			colorMultiplier[3][3] = openfl_ColorMultiplierv.w;
			
			color = clamp (openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
			
			if (color.a > 0.0) {
				
				gl_FragColor = vec4 (color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
				
			} else {
				
				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
				
			}
			
		} else {
			
			gl_FragColor = color * openfl_Alphav;
			
		}")
	@:glFragmentSource(#if emscripten "#pragma header
		
		void main(void) {
			
			#pragma body
			
			gl_FragColor = gl_FragColor.bgra;
			
		}" #else "#pragma header
		
		void main(void) {
			
			#pragma body
			
		}" #end
	)
	public function new(code:ByteArray = null)
	{
		super(code);
	}
}