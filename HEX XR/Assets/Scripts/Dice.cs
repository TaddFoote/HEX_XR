using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dice : MonoBehaviour {
    
    // Create a list to store the sides of the dice for tracking final roll position.
    public List<Transform> dSides = new List<Transform>();

    //private
    float highestFace_Y_val = 0.0f;
    string restingNumberName;
    int finalRoll;
    Rigidbody rb;


    void Awake()
    {

        //transform.SetParent(groundPlaneStage.transform);
    }
    void Start ()
    {
        rb = GetComponent<Rigidbody>();
    }
	

	void Update ()
    {
        if (rb.IsSleeping() && highestFace_Y_val == 0) getRestingNumber();
    }


    //Determine which side of the dice is "SHOWING"
    public void getRestingNumber()
    {
        foreach (Transform side in dSides)
        {
            if (side.position.y > highestFace_Y_val)
            {
                highestFace_Y_val = side.position.y;
                restingNumberName = side.name;
            }
        }


        string str1 = restingNumberName;
        string str2 = "loc_";
        string result = str1.Replace(str2, "");
        int finalRoll = System.Convert.ToInt32(result);
        Debug.Log("Hi Warren, resting number is " + finalRoll);
    }
}
