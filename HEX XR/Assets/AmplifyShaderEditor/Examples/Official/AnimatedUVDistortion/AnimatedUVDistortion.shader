// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TFA/TFA_hexgrid_02"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_MainTexture("Main Texture", 2D) = "white" {}
		_DistortTexture("Distort Texture", 2D) = "white" {}
		[HDR]_TintColor("Tint Color", Color) = (1,0.4196078,0,1)
		_Speed("Speed", Range( 0 , 1)) = 0
		_localVertOffset("localVertOffset", Range( -10 , 10)) = 0
		_UVDistortIntensity("UV Distort Intensity", Range( 0 , 1)) = 0
		_Vector0("Vector 0", Vector) = (0,-0.333,0,0)
		_tex_scanLines("tex_scanLines", 2D) = "white" {}
		_tex_hexChunkMASK("tex_hexChunkMASK", 2D) = "white" {}
		_numScanLinesAprox("numScanLinesAprox", Range( 0 , 200)) = 0
		_maskAmount("maskAmount", Range( -0.09 , 0.5)) = 0.3483937
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_distortion("distortion", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TreeTransparentCutout"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
		};

		uniform float _distortion;
		uniform sampler2D _TextureSample1;
		uniform float4 _TintColor;
		uniform sampler2D _MainTexture;
		uniform float _Speed;
		uniform sampler2D _DistortTexture;
		uniform float _UVDistortIntensity;
		uniform float4 _MainTexture_ST;
		uniform sampler2D _tex_scanLines;
		uniform float2 _Vector0;
		uniform float _numScanLinesAprox;
		uniform float _maskAmount;
		uniform sampler2D _tex_hexChunkMASK;
		uniform float _localVertOffset;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			v.vertex.xyz += ( ase_vertex3Pos * _localVertOffset );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 appendResult85 = (float2(ase_screenPosNorm.x , ase_screenPosNorm.y));
			float2 temp_cast_1 = (0.1).xx;
			float2 panner90 = ( ase_screenPosNorm.xy + 1 * _Time.y * temp_cast_1);
			float2 temp_cast_3 = (0.15).xx;
			float2 panner91 = ( ase_screenPosNorm.xy + 1 * _Time.y * temp_cast_3);
			o.Normal = ( float3( ( appendResult85 / ase_screenPosNorm.w ) ,  0.0 ) + ( _distortion * BlendNormals( UnpackNormal( tex2D( _TextureSample1, panner90 ) ) , UnpackScaleNormal( tex2D( _TextureSample1, panner91 ) ,0.3 ) ) ) );
			float mulTime10 = _Time.y * _Speed;
			float2 panner11 = ( float2( 0,0 ) + mulTime10 * float2( -1,-1 ));
			float2 uv_TexCoord9 = i.uv_texcoord * float2( 1,1 ) + panner11;
			float2 temp_cast_6 = (_UVDistortIntensity).xx;
			float4 tex2DNode6 = tex2D( _DistortTexture, temp_cast_6 );
			float mulTime15 = _Time.y * _Speed;
			float2 panner17 = ( float2( 0,0 ) + mulTime15 * float2( 1,0.5 ));
			float2 uv_TexCoord18 = i.uv_texcoord * float2( 1,1 ) + panner17;
			float4 temp_output_20_0 = ( _TintColor * ( tex2D( _MainTexture, ( float4( uv_TexCoord9, 0.0 , 0.0 ) + tex2DNode6 ).rg ) * tex2D( _MainTexture, ( float4( uv_TexCoord18, 0.0 , 0.0 ) + tex2DNode6 ).rg ) ) );
			o.Albedo = temp_output_20_0.rgb;
			float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST.xy + _MainTexture_ST.zw;
			float4 tex2DNode41 = tex2D( _MainTexture, uv_MainTexture );
			o.Emission = ( temp_output_20_0 + tex2DNode41 ).rgb;
			float mulTime36 = _Time.y * 1;
			float2 panner37 = ( ( ase_screenPosNorm * _numScanLinesAprox ).xy + mulTime36 * _Vector0);
			o.Alpha = ( tex2DNode41 + tex2D( _tex_scanLines, panner37 ) ).r;
			clip( ( _maskAmount + tex2D( _tex_hexChunkMASK, ase_screenPosNorm.xy ) ).r - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15001
-1673;51;1666;974;1024.587;90.7522;1.020306;True;False
Node;AmplifyShaderEditor.RangedFloatNode;23;-2400.123,58.86468;Float;False;Property;_Speed;Speed;4;0;Create;True;0;0;False;0;0;0.0666;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;10;-2010.17,-83.02798;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-1987.916,494.4533;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1916.708,106.293;Float;False;Property;_UVDistortIntensity;UV Distort Intensity;6;0;Create;True;0;0;False;0;0;0.71;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;11;-1799.049,-262.9515;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-1,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;17;-1759.781,366.8382;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-1607.091,-484.697;Float;False;Constant;_Float3;Float 3;13;0;Create;True;0;0;False;0;0.15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-1636.972,-911.9068;Float;False;Constant;_Float2;Float 2;13;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-1558.098,90.11827;Float;True;Property;_DistortTexture;Distort Texture;2;0;Create;True;0;0;False;0;None;cd460ee4ac5c1e746b7a734cc7cc64dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-1225.597,-252.8895;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-1272.574,354.2421;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;31;-2085.102,1006.851;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;90;-1372.568,-858.1432;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-1190.137,-526.9426;Float;False;Constant;_Float1;Float 1;13;0;Create;True;0;0;False;0;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;91;-1371.414,-718.4724;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1246.647,800.7537;Float;False;Property;_numScanLinesAprox;numScanLinesAprox;10;0;Create;True;0;0;False;0;0;180;0;200;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-978.4656,-159.0065;Float;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-1013.526,448.6211;Float;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;89;-920.0815,-848.9093;Float;True;Property;_TextureSample2;Texture Sample 2;12;0;Create;True;0;0;False;0;None;dd2fd2df93418444c8e280f1d34deeb5;True;0;True;bump;Auto;True;Instance;87;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;87;-919.5987,-606.4434;Float;True;Property;_TextureSample1;Texture Sample 1;12;0;Create;True;0;0;False;0;None;dd2fd2df93418444c8e280f1d34deeb5;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;36;-742.5435,682.231;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-949.8638,748.0579;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;1;-856.8282,-182.0895;Float;True;Property;_MainTexture;Main Texture;1;0;Create;True;0;0;False;0;None;0ef66daf2a0a9e04ea9427e29283302f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;38;-823.5453,556.7658;Float;False;Property;_Vector0;Vector 0;7;0;Create;True;0;0;False;0;0,-0.333;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;14;-851.3542,1.76078;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Instance;1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;37;-548.412,598.9073;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;7;-899.2653,-385.0078;Float;False;Property;_TintColor;Tint Color;3;1;[HDR];Create;True;0;0;False;0;1,0.4196078,0,1;0.7029893,0.6067799,0.9485294,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;97;-557.1731,-868.0841;Float;False;Property;_distortion;distortion;13;0;Create;True;0;0;False;0;0;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;85;-933.5802,-1067.932;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-530.4052,-105.6451;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;92;-558.2853,-693.6515;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;39;-302.3172,417.5416;Float;True;Property;_tex_scanLines;tex_scanLines;8;0;Create;True;0;0;False;0;None;96428cb54654d1a47a32a8706437e183;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-257.1744,-689.8011;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-707.561,470.2782;Float;False;Property;_localVertOffset;localVertOffset;5;0;Create;True;0;0;False;0;0;1;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-301.6053,-187.0681;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;96;-739.6868,-1024.097;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;46;-204.768,929.4032;Float;True;Property;_tex_hexChunkMASK;tex_hexChunkMASK;9;0;Create;True;0;0;False;0;None;de47ffc3b25af1843be2b8a4bfb85ead;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;41;-447.4963,106.0719;Float;True;Property;_tex_hexPiece;tex_hexPiece;1;0;Create;True;0;0;False;0;None;0ef66daf2a0a9e04ea9427e29283302f;True;0;False;white;Auto;False;Instance;1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;82;-401.9017,779.0344;Float;False;Property;_maskAmount;maskAmount;11;0;Create;True;0;0;False;0;0.3483937;0.5;-0.09;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;28;-635.0967,277.041;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;99;-15.60388,-615.7184;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;175.1157,721.8723;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;100;-120.0686,-435.442;Float;False;Global;_GrabScreen0;Grab Screen 0;14;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;45;46.88062,138.7927;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-298.5427,309.2474;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;2.098877,-11.34808;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;267.9615,-227.9616;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;TFA/TFA_hexgrid_02;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;False;0;True;TreeTransparentCutout;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;SrcAlpha;OneMinusSrcAlpha;2;SrcAlpha;OneMinusSrcAlpha;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;23;0
WireConnection;15;0;23;0
WireConnection;11;1;10;0
WireConnection;17;1;15;0
WireConnection;6;1;13;0
WireConnection;9;1;11;0
WireConnection;18;1;17;0
WireConnection;90;0;31;0
WireConnection;90;2;94;0
WireConnection;91;0;31;0
WireConnection;91;2;95;0
WireConnection;12;0;9;0
WireConnection;12;1;6;0
WireConnection;19;0;18;0
WireConnection;19;1;6;0
WireConnection;89;1;90;0
WireConnection;87;1;91;0
WireConnection;87;5;88;0
WireConnection;43;0;31;0
WireConnection;43;1;32;0
WireConnection;1;1;12;0
WireConnection;14;1;19;0
WireConnection;37;0;43;0
WireConnection;37;2;38;0
WireConnection;37;1;36;0
WireConnection;85;0;31;1
WireConnection;85;1;31;2
WireConnection;8;0;1;0
WireConnection;8;1;14;0
WireConnection;92;0;89;0
WireConnection;92;1;87;0
WireConnection;39;1;37;0
WireConnection;98;0;97;0
WireConnection;98;1;92;0
WireConnection;20;0;7;0
WireConnection;20;1;8;0
WireConnection;96;0;85;0
WireConnection;96;1;31;4
WireConnection;46;1;31;0
WireConnection;99;0;96;0
WireConnection;99;1;98;0
WireConnection;83;0;82;0
WireConnection;83;1;46;0
WireConnection;45;0;41;0
WireConnection;45;1;39;0
WireConnection;29;0;28;0
WireConnection;29;1;30;0
WireConnection;42;0;20;0
WireConnection;42;1;41;0
WireConnection;0;0;20;0
WireConnection;0;1;99;0
WireConnection;0;2;42;0
WireConnection;0;9;45;0
WireConnection;0;10;83;0
WireConnection;0;11;29;0
ASEEND*/
//CHKSM=A185C2E84D27A756D2AB925F90FC5ED8E84D0294