// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TFA/TFA_hexgrid_01"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_scanlineSpeed("scanlineSpeed", Vector) = (0,-0.333,0,0)
		_Vector0("Vector 0", Vector) = (0,-0.333,0,0)
		_scanline_speed("scanline_speed", Range( 0 , 0.333)) = 0
		_TextureSample7("Texture Sample 7", 2D) = "white" {}
		_Float2("Float 2", Range( 0 , 2)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend One One
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform sampler2D _TextureSample1;
		uniform float2 _scanlineSpeed;
		uniform float _scanline_speed;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform sampler2D _TextureSample7;
		uniform float2 _Vector0;
		uniform float _Float2;

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime87 = _Time.y * 1;
			float2 temp_cast_0 = (_scanline_speed).xx;
			float2 uv_TexCoord90 = i.uv_texcoord * temp_cast_0 + float2( 0,0 );
			float2 panner89 = ( uv_TexCoord90 + mulTime87 * _scanlineSpeed);
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			o.Emission = ( tex2D( _TextureSample1, panner89 ) + tex2D( _TextureSample0, uv_TextureSample0 ) ).rgb;
			float mulTime142 = _Time.y * 1;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float4 normalizeResult137 = normalize( ase_screenPosNorm );
			float2 temp_cast_2 = (_Float2).xx;
			float2 uv_TexCoord138 = i.uv_texcoord * temp_cast_2 + float2( 0,0 );
			float2 panner143 = ( ( normalizeResult137 * float4( uv_TexCoord138, 0.0 , 0.0 ) ).xy + mulTime142 * _Vector0);
			o.Alpha = tex2D( _TextureSample7, panner143 ).a;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.screenPos = IN.screenPos;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15001
-1543;168;1522;788;918.6558;-871.8033;1.379971;True;False
Node;AmplifyShaderEditor.RangedFloatNode;140;-403.7547,1675.246;Float;False;Property;_Float2;Float 2;18;0;Create;True;0;0;False;0;0;0.05851554;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;80;-906.4911,662.0649;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;92;-432.6497,28.11177;Float;False;Property;_scanline_speed;scanline_speed;9;0;Create;True;0;0;False;0;0;0.1032938;0;0.333;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;137;-93.39819,1521.29;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;138;-109.2254,1655.023;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;90;-100.3722,7.947865;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;87;-173.0199,-120.5966;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;88;-378.6378,-230.548;Float;False;Property;_scanlineSpeed;scanlineSpeed;7;0;Create;True;0;0;False;0;0,-0.333;0,-0.03;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;141;209.3197,1421.268;Float;False;Property;_Vector0;Vector 0;8;0;Create;True;0;0;False;0;0,-0.333;0,-0.03;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;231.3526,1633.229;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;142;438.9375,1526.419;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;89;116.8176,-198.0293;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;143;507.9751,1453.787;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;84;363.7718,-165.0759;Float;True;Property;_TextureSample1;Texture Sample 1;6;0;Create;True;0;0;False;0;None;ff4ca6f01260c98408ff1c7950610994;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;83;373.3649,74.68372;Float;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;None;0ef66daf2a0a9e04ea9427e29283302f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;135;561.8511,875.1376;Float;False;Constant;_Float1;Float 1;16;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;97;-110.3998,765.3605;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-343.9875,700.1843;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;131;522.0229,643.2439;Float;True;Property;_TextureSample6;Texture Sample 6;16;0;Create;True;0;0;False;0;None;de47ffc3b25af1843be2b8a4bfb85ead;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-344.059,1134.6;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;928.1591,62.8762;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;819.7582,836.5067;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;136;845.3754,1121.118;Float;True;Property;_TextureSample7;Texture Sample 7;17;0;Create;True;0;0;False;0;None;40a791a44e0c517429c327adaa79de98;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;49;-106.4716,491.0621;Float;False;Property;_maskStrength;maskStrength;1;0;Create;True;0;0;False;0;0.5;2;-1;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;115;-339.7336,1231.502;Float;False;Property;_flame3Speed;flame3Speed;12;0;Create;True;0;0;False;0;0,0;0,-0.03;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TFHCRemapNode;78;595.9031,478.0606;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;-339.8139,914.7394;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;124;-638.2319,768.4381;Float;False;Constant;_flame1Size;flame1Size;14;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;114;-1.20612,1210.868;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;133;281.484,512.5939;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-691.7803,1084.918;Float;False;Property;_flame3Size;flame3Size;14;0;Create;True;0;0;False;0;0.5;1.882353;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-657.3051,930.1468;Float;False;Property;_flame2Size;flame2Size;15;0;Create;True;0;0;False;0;2;0.5291346;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;101;-348.7688,786.7109;Float;False;Property;_flame1speed;flame1speed;13;0;Create;True;0;0;False;0;0,0;0,-0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;96;352.8253,327.7502;Float;True;Property;_TextureSample2;Texture Sample 2;10;0;Create;True;0;0;False;0;None;bd3d3ec57869d48429434b48a14d899c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;113;-3.908493,993.4869;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;102;247.1339,966.1072;Float;True;Property;_TextureSample3;Texture Sample 3;2;0;Create;True;0;0;False;0;None;a96bb977c50e0f94594a0d2c1761b2a4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;111;-338.5721,1009.462;Float;False;Property;_flame2speed;flame2speed;11;0;Create;True;0;0;False;0;0,0;0,-0.08;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;106;-727.6105,1425.832;Float;True;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;841.3708,643.6844;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;53;252.4603,750.5095;Float;True;Property;_TextureSample4;Texture Sample 4;4;0;Create;True;0;0;False;0;None;a96bb977c50e0f94594a0d2c1761b2a4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;103;214.7814,1214.808;Float;True;Property;_TextureSample5;Texture Sample 5;3;0;Create;True;0;0;False;0;None;a96bb977c50e0f94594a0d2c1761b2a4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;82;931.2372,514.0772;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1180.798,153.4618;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;TFA/TFA_hexgrid_01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.52;True;True;0;True;TransparentCutout;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;4;One;One;0;Zero;Zero;OFF;OFF;0;False;0.33;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;137;0;80;0
WireConnection;138;0;140;0
WireConnection;90;0;92;0
WireConnection;139;0;137;0
WireConnection;139;1;138;0
WireConnection;89;0;90;0
WireConnection;89;2;88;0
WireConnection;89;1;87;0
WireConnection;143;0;139;0
WireConnection;143;2;141;0
WireConnection;143;1;142;0
WireConnection;84;1;89;0
WireConnection;97;0;123;0
WireConnection;97;2;101;0
WireConnection;123;0;80;0
WireConnection;123;1;124;0
WireConnection;131;1;80;0
WireConnection;117;0;80;0
WireConnection;117;1;118;0
WireConnection;85;0;84;0
WireConnection;85;1;83;0
WireConnection;110;0;53;0
WireConnection;110;1;102;0
WireConnection;110;2;103;0
WireConnection;136;1;143;0
WireConnection;78;0;133;0
WireConnection;119;0;80;0
WireConnection;119;1;125;0
WireConnection;114;0;117;0
WireConnection;114;2;115;0
WireConnection;133;0;49;0
WireConnection;113;0;119;0
WireConnection;113;2;111;0
WireConnection;102;1;113;0
WireConnection;134;0;131;0
WireConnection;134;1;135;0
WireConnection;53;1;97;0
WireConnection;103;1;114;0
WireConnection;82;0;78;0
WireConnection;82;1;134;0
WireConnection;0;2;85;0
WireConnection;0;9;136;4
ASEEND*/
//CHKSM=8190BD990F678A725C96062F33B4462CD83CFD9A