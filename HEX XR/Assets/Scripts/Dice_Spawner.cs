using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dice_Spawner : MonoBehaviour
{
    public Transform TFanchor;      // Transform to track/anchor dice.
    public float throwForce = 3f;           // How hard are we throwing the dice?

    public Color rayColor = Color.red;      // Editor color for 'path'.
    public List<Transform> pathObjs = new List<Transform>();    // List of the 'path' waypoints.

    public List<Dice> diceObjs = new List<Dice>();              // List of the Dice transforms to be thrown.


    // Private variables.
    Transform[] arryOfTransforms;
    bool gyroEnabled;
    Gyroscope m_Gyro;
    GameObject spawnerContainer;
    Quaternion rot;


    void Start()
    {
        // Create a new GameObject to become the parent transform of the Spawner (old method.. Now is manually parented under ARCamera).
        //spawnerContainer = new GameObject ("Spawner Container");
        //spawnerContainer.transform.position = transform.position;
        //transform.SetParent (spawnerContainer.transform);

        // Check to see if device has Gyro, if so enable.
        //gyroEnabled = EnableGyro ();
    }


    void Update()
    {
        if (gyroEnabled)
        {
            //transform.localRotation = m_Gyro.attitude * rot;
        }
        
        if (Input.GetButtonDown("Fire1"))
        //if (Input.GetKeyDown(KeyCode.Space))
            {
            ThrowDice(diceObjs);
        }
    }

    public void TriggerThrowDice()
    {
        ThrowDice(diceObjs);
    }

    void ThrowDice(List<Dice> tmpDiceObjs)
    {        
        foreach (Dice dice in tmpDiceObjs)
        {
            Dice clone;
            clone = Instantiate(dice, transform.position, transform.rotation) as Dice;
            clone.transform.SetParent (TFanchor);

            Rigidbody tmp_rb = clone.GetComponent<Rigidbody>();
            float tmp_force = Random.Range(throwForce - 1f, throwForce + 1f);
            float tmp_torque = Random.Range(1f, 10f) * throwForce;
            Vector3 tmp_dir = new Vector3(Random.Range(0.0f, 360f), Random.Range(0.0f, 360f), Random.Range(0.0f, 360f));
            tmp_rb.AddForce(tmp_rb.transform.forward * tmp_force, ForceMode.Impulse);
            tmp_rb.AddForce(tmp_rb.transform.up * tmp_force, ForceMode.Impulse);
            tmp_rb.AddTorque(tmp_dir.normalized * tmp_torque , ForceMode.Impulse);
        }
    }

    private bool EnableGyro()
    {
        if (SystemInfo.supportsGyroscope)
        {
            m_Gyro = Input.gyro;
            m_Gyro.enabled = true;
            spawnerContainer.transform.rotation = Quaternion.Euler(90f, -90f, 0f);
            rot = new Quaternion(0, 0, 1, 0);
            return true;
        }
        return false;
    }

    void GyroModifySpawner()
    {
        Debug.Log(m_Gyro.attitude);
        transform.rotation = GyroToUnity(m_Gyro.attitude);
    }

    private static Quaternion GyroToUnity(Quaternion q)
    {
        // The Gyroscope is right-handed.  Unity is left handed.
        return new Quaternion(q.x, q.y, q.z, q.w);
    }



    // Create a 'path' viewable in the Editor for the spawner.
    private void OnDrawGizmos()
    {
        Gizmos.color = rayColor;
        arryOfTransforms = GetComponentsInChildren<Transform>();
        pathObjs.Clear();

        foreach (Transform pathObj in arryOfTransforms)
        {
            if (pathObj != this.transform)
            {
                pathObjs.Add(pathObj);
            }

            for (int i = 0; i < pathObjs.Count; ++i)
            {
                Vector3 position = pathObjs[i].position;
                if (i > 0)
                {
                    Vector3 previous = pathObjs[i - 1].position;
                    Gizmos.DrawLine(previous, position);
                    Gizmos.DrawWireSphere(position, 0.3f);
                }
            }
        }
    }
}
