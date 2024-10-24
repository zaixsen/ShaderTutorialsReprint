using Codice.Client.BaseCommands;
using log4net;
using log4net.Core;
using NUnit.Framework;
using Palmmedia.ReportGenerator.Core;
using System;
using System.IO;
using System.Linq;
using Unity.VisualScripting.YamlDotNet.Core.Tokens;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEditor.SceneTemplate;
using UnityEngine;
using UnityEngine.Profiling;
using UnityEngine.SceneManagement;
using static UnityEditor.ShaderData;

public enum ShaderType
{
    UnLit,
    StandardSurfaceShader
}

public class ShaderBuildTool : EditorWindow
{

    string floderPath = string.Empty;
    static string[] alreadyExistedPaths;
    string shaderCode;
    ShaderType shaderType;
    [MenuItem("Tool/Build Shader Scene")]
    public static void BuildShader()
    {
        GetWindow<ShaderBuildTool>("Build Shader Scene").Show();
        alreadyExistedPaths = GetAllFloderPath();
    }


    private void OnGUI()
    {
        GUILayout.Space(10);
        GUILayout.Label("�����ļ�������");
        GUILayout.Space(10);
        floderPath = EditorGUILayout.TextField(floderPath);
        shaderType = (ShaderType)EditorGUILayout.EnumPopup(shaderType);

        if (!CheckPath(floderPath) || floderPath == string.Empty)
        {
            EditorGUILayout.HelpBox("Path Duplication", MessageType.Error);
            return;
        }

        if (GUILayout.Button("Build Shader Scene Floder"))
        {
            string fillPath = Application.dataPath + @"\" + floderPath;
            //�����ļ���
            Directory.CreateDirectory(fillPath);
            //��������
            Scene scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
            EditorSceneManager.SaveScene(scene, fillPath + $"\\{floderPath}.unity");
            //����Shader
            switch (shaderType)
            {
                case ShaderType.UnLit:
                    shaderCode = GetUnlitCode();
                    break;
                case ShaderType.StandardSurfaceShader:
                    shaderCode = GetStandardSurfaceShader();
                    break;
                default:
                    break;
            }
            File.WriteAllText(fillPath + $"\\{floderPath}.shader", shaderCode);

            AssetDatabase.Refresh();

            //Material material = new Material(Shader.Find("Reprint\\" + floderPath));
            Material material = new Material(Shader.Find("Reprint/" + floderPath));

            AssetDatabase.CreateAsset(material, $"Assets/{floderPath}/{floderPath}.mat");

            AssetDatabase.Refresh();
        }

    }

    private string GetStandardSurfaceShader()
    {
        return @"Shader ""Reprint/" + floderPath + @"""
{
    Properties
    {
        _Color (""Color"", Color) = (1,1,1,1)
        _MainTex (""Albedo (RGB)"", 2D) = ""white"" {}
        _Glossiness (""Smoothness"", Range(0,1)) = 0.5
        _Metallic (""Metallic"", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { ""RenderType""=""Opaque"" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack ""Diffuse""
}
";
    }

    private string GetUnlitCode()
    {
        return @"Shader ""Reprint/" + floderPath + @"""
    {
        Properties
        {
           _MainTex(""Texture"", 2D) = ""white"" { }
        }
        SubShader
        {
          Tags { ""RenderType"" = ""Opaque"" }
          LOD 100

            Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                 // make fog work
                #pragma multi_compile_fog

                # include ""UnityCG.cginc""

                struct appdata
                {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    UNITY_FOG_COORDS(1)
                    float4 vertex : SV_POSITION;
                };

                sampler2D _MainTex;
                 float4 _MainTex_ST;

                v2f vert(appdata v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    UNITY_TRANSFER_FOG(o, o.vertex);
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    // sample the texture
                    fixed4 col = tex2D(_MainTex, i.uv);
                    // apply fog
                    UNITY_APPLY_FOG(i.fogCoord, col);
                    return col;
                }
                ENDCG
                }
            }
        }";
    }

    public bool CheckPath(string newPath)
    {
        foreach (var path in alreadyExistedPaths)
            if (newPath.Equals(path))
                return false;
        return true;
    }

    public static string[] GetAllFloderPath()
    {
        string[] fillFloder = Directory.GetDirectories(Application.dataPath);

        for (int i = 0; i < fillFloder.Length; i++)
            fillFloder[i] = fillFloder[i].Replace(Application.dataPath + @"\", "");

        return fillFloder;
    }
}
