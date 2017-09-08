/**
 * Criado por Everton Nogueira em 08/12/2016
 */

package la.foton.brb.myphone;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Environment;
import android.security.KeyChain;
import android.security.KeyChainException;
import android.util.Base64;
import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.security.Key;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

@TargetApi(19)
public class FotonKeyChain extends CordovaPlugin {
    private CallbackContext callbackContext;

    public FotonKeyChain() {
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        this.callbackContext = callbackContext;
        try{
            if (action.equals("armazenar")) {
                return armazenaNovaChave(String.valueOf(args.get(0)), String.valueOf(args.get(1)));
            }
            if (action.equals("recuperar")) {
                return recuperaChave(String.valueOf(args.get(0)));
            }
        }catch (Exception e){}

        this.callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR));
        return false;
    }

    public boolean armazenaNovaChave(String chave, String valor) throws IOException {
        ObjectOutputStream objectOut = null;
        try{
            Map<String, String> keyMap = new HashMap<String, String>();
            keyMap.put(chave, valor);
            objectOut = new ObjectOutputStream(new BufferedOutputStream(new FileOutputStream(this.cordova.getActivity().getApplicationContext().getFilesDir() + "/myKey.key")));
            objectOut.writeObject(keyMap);
        }catch(Exception e){
        	this.callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR));
            return false;
        }finally {
            if(objectOut != null) {
                objectOut.close();
            }
        }
        this.callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK));
        return true;
    }

    public boolean recuperaChave(String chave) throws IOException {
        InputStream readStream = null;
        try{
            ObjectInputStream objectIn = new ObjectInputStream(new BufferedInputStream(new FileInputStream(this.cordova.getActivity().getApplicationContext().getFilesDir() + "/myKey.key")));
            Map<String, String> keyMap = (HashMap<String, String>)objectIn.readObject();
            String key = keyMap.get(chave);
            if(key != null) {
                this.callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, key));
                return true;
            }
        } catch (Exception e) {
        	this.callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR));
            return false;
        }finally {
            if(readStream != null) {
                readStream.close();
            }
        }
        //Nao encontrou uma chave
        this.callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR));
        return false;
    }

}