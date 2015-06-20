using UnityEngine;
using System.Collections;

public class visibility : MonoBehaviour {
	public static string act1="1";
	public static string act2="2";
	public static string act3="3";
	public static string act4="x";
	public static string act5="5";
	public static string act6="6";
	private float tr=1f;
	
	
	// Use this for initialization
	void Start () {
	
	}
	
	void OnGUI(){
		
		if (this.name=="cloud1"){
		if (GUI.Button(new Rect(30,30,20,20),act1)){
				foreach (Transform child in transform)
{
			
    child.GetComponent<Renderer>().enabled=true;
			
			}
			act1="x";
			act2="2";
			act3="3";
			act4="4";
			act5="5";
			act6="6";
				
		}
			
		}
		
			if (this.name=="cloud2"){
		if (GUI.Button(new Rect(60,30,20,20),act2)){
				foreach (Transform child in transform)
{
    child.GetComponent<Renderer>().enabled=true;
					
			}
				act1="1";
			act2="x";
			act3="3";
			act4="4";
			act5="5";
			act6="6";
		}
			
		}
		
		
			if (this.name=="cloud3"){
		if (GUI.Button(new Rect(90,30,20,20),act3)){
				foreach (Transform child in transform)
{
    child.GetComponent<Renderer>().enabled=true;
			}
				act1="1";
			act2="2";
			act3="x";
			act4="4";
			act5="5";
			act6="6";
		}
			
		}
		
		
			if (this.name=="cloud4"){
		if (GUI.Button(new Rect(120,30,20,20),act4)){
				foreach (Transform child in transform)
{
    child.GetComponent<Renderer>().enabled=true;
			}
				act1="1";
			act2="2";
			act3="3";
			act4="x";
			act5="5";
			act6="6";
		}
			
		}
		
		
			if (this.name=="cloud5"){
		if (GUI.Button(new Rect(150,30,20,20),act5)){
				foreach (Transform child in transform)
{
    child.GetComponent<Renderer>().enabled=true;
			}
				act1="1";
			act2="2";
			act3="3";
			act4="4";
			act5="x";
			act6="6";
		}
			
		}
		
		
			if (this.name=="cloud6"){
		if (GUI.Button(new Rect(180,30,20,20),act6)){
				foreach (Transform child in transform)
{
    child.GetComponent<Renderer>().enabled=true;
			}
				act1="1";
			act2="2";
			act3="3";
			act4="4";
			act5="5";
			act6="x";
		}
			
		}

		
		
	}
	

	
	// Update is called once per frame
	void Update () {
		
		if (tr!=transparency.transp){
		foreach (Transform child in transform)
{
				tr=transparency.transp;
		child.GetComponent<Renderer>().material.color = new Color(1f,1f,1f,tr);
			}
		}
		
	if (this.name=="cloud1" && this.transform.FindChild("l1").GetComponent<Renderer>().enabled==true && act1=="1"){
			foreach (Transform child in transform)
{
    child.GetComponent<Renderer>().enabled=false;
			}
		}
		
		
			if (this.name=="cloud2" && this.transform.FindChild("l1").GetComponent<Renderer>().enabled==true && act2=="2"){
			foreach (Transform child in transform)
{
    child.GetComponent<Renderer>().enabled=false;
			}
		}
		
		
			if (this.name=="cloud3" && this.transform.FindChild("l1").GetComponent<Renderer>().enabled==true && act3=="3"){
			foreach (Transform child in transform)
{
    child.GetComponent<Renderer>().enabled=false;
			}
		}
		
		
			if (this.name=="cloud4" && this.transform.FindChild("l1").GetComponent<Renderer>().enabled==true && act4=="4"){
			foreach (Transform child in transform)
{
    child.GetComponent<Renderer>().enabled=false;
			}
		}
		
		
			if (this.name=="cloud5" && this.transform.FindChild("l1").GetComponent<Renderer>().enabled==true && act5=="5"){
			foreach (Transform child in transform)
{
    child.GetComponent<Renderer>().enabled=false;
			}
		}
		
		
			if (this.name=="cloud6" && this.transform.FindChild("l1").GetComponent<Renderer>().enabled==true && act6=="6"){
			foreach (Transform child in transform)
{
    child.GetComponent<Renderer>().enabled=false;
			}
		}
		
	}
}
