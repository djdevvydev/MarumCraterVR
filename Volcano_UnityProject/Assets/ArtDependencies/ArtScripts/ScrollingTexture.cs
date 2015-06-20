using UnityEngine;
using System.Collections;

public class ScrollingTexture : MonoBehaviour {
	[SerializeField]
	private Vector2 uvSpeed = new Vector2(0.5f, 0.0f);
	[SerializeField]
	private string textureName = "_MainTex";
	[SerializeField]
	private bool enableWave;

	private Material objectMaterial;
	private Vector2 uvOffset = Vector2.zero;

	// Use this for initialization
	void Start () {
		objectMaterial = this.GetComponent<MeshRenderer> ().material;
	}
	
	// Update is called once per frame
	void LateUpdate () {
		uvOffset += (uvSpeed * Time.deltaTime);
		if (enableWave) {
			uvOffset = new Vector2 (uvOffset.x, Mathf.Cos (uvOffset.x));
		}
		objectMaterial.SetTextureOffset (textureName, uvOffset);
	}
}
