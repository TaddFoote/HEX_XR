// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TFA_animated_MASK"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_DissolveAmount("DissolveAmount", Range( 0 , 1)) = 0
		_size("size", Range( 0 , 1)) = 0
		_speed("speed", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _DissolveAmount;
		uniform sampler2D _TextureSample0;
		uniform float2 _speed;
		uniform float _size;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Alpha = 1;
			float mulTime14 = _Time.y * 1;
			float2 temp_cast_0 = (_size).xx;
			float2 uv_TexCoord7 = i.uv_texcoord * temp_cast_0 + float2( 0,0 );
			float2 temp_cast_1 = (_size).xx;
			float2 uv_TexCoord11 = i.uv_texcoord * temp_cast_1 + float2( 0,0 );
			float2 panner13 = ( ( uv_TexCoord7 + uv_TexCoord11 ) + mulTime14 * _speed);
			clip( ( (-0.6 + (( 1.0 - _DissolveAmount ) - 0) * (0.6 - -0.6) / (1 - 0)) + tex2D( _TextureSample0, panner13 ) ).r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15001
-1673;51;1522;788;1702.451;234.8239;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;8;-1296.589,92.71587;Float;False;Property;_size;size;3;0;Create;True;0;0;False;0;0;0.328648;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-996.2855,257.8167;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-997.5849,136.9162;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-1008,14;Float;False;Property;_DissolveAmount;DissolveAmount;2;0;Create;True;0;0;False;0;0;0.5537915;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-754.4858,196.7163;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;15;-1164.251,447.6762;Float;False;Property;_speed;speed;4;0;Create;True;0;0;False;0;0,0;0.03,0.03;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;14;-990.0513,651.7763;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;13;-704.0519,357.9765;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;3;-701,18;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-514.5006,320.5999;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;4;-491,17;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-233,114;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;TFA_animated_MASK;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;8;0
WireConnection;7;0;8;0
WireConnection;10;0;7;0
WireConnection;10;1;11;0
WireConnection;13;0;10;0
WireConnection;13;2;15;0
WireConnection;13;1;14;0
WireConnection;3;0;2;0
WireConnection;1;1;13;0
WireConnection;4;0;3;0
WireConnection;5;0;4;0
WireConnection;5;1;1;0
WireConnection;0;10;5;0
ASEEND*/
//CHKSM=A02D9C18BAA9BFF857CB318144A1179F2EC183D1