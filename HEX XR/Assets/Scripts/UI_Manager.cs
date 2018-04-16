using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UI_Manager : MonoBehaviour {

    public Dice_Spawner diceSpawner;


    Ray ray;
    RaycastHit hit;

    // Use this for initialization
    void Start()
    {
        Debug.Log(Screen.orientation);
    }

    // Update is called once per frame
    void Update()
    {

        if (Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Began)
        {
            ray = Camera.main.ScreenPointToRay(Input.GetTouch(0).position);

            Debug.DrawRay(ray.origin, ray.direction * 20, Color.red);
            if (Physics.Raycast(ray, out hit, Mathf.Infinity))
            {
                //Debug.Log("Hit Something");
                diceSpawner.TriggerThrowDice();
            }
        }
    }
}
