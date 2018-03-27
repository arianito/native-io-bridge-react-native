package com.iobridgemodule;


import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Environment;
import android.util.Base64;
import android.util.Log;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.UUID;

/**
 * Created by aryan on 3/27/18.
 */

public class StorageModule extends ReactContextBaseJavaModule {


    public StorageModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    private String resolvePath(String to) {
        return getReactApplicationContext().getFilesDir().getAbsolutePath() + '/' + to;
    }

    @ReactMethod
    public void saveSync(String to, String base64) {

        try {
            File f = new File(resolvePath(to));
            f.getParentFile().mkdirs();
            FileOutputStream stream = new FileOutputStream(f);
            try {
                stream.write(base64.getBytes());
            } finally {
                stream.close();
            }
        } catch (Exception ignored) {
        }
    }

    @ReactMethod
    public void save(String to, String base64, Promise promise) {
        try {
            File f = new File(resolvePath(to));
            f.getParentFile().mkdirs();
            FileOutputStream stream = new FileOutputStream(f);
            try {
                stream.write(base64.getBytes());
            } finally {
                stream.close();
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject("IO error", e.getMessage());
        }
    }


    @ReactMethod
    public void exists(String to, Promise promise) {
        File f = new File(resolvePath(to));
        promise.resolve(f.exists());
    }

    @ReactMethod
    public void path(String to, Promise promise) {
        promise.resolve(getReactApplicationContext().getFilesDir().getAbsolutePath() + '/' + to);
    }

    @ReactMethod
    public void read(String from, Promise promise) {
        try {
            File f = new File(resolvePath(from));
            FileInputStream fin = new FileInputStream(f);
            BufferedReader reader = new BufferedReader(new InputStreamReader(fin));
            StringBuilder sb = new StringBuilder();
            String line = null;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            reader.close();
            fin.close();
            promise.resolve(sb.toString());
        } catch (Exception e) {
            promise.reject("IO error", e.getMessage());
        }
    }


    @ReactMethod
    public void saveToGallery(String base64){

        try {
            String pureBase64 = base64.substring(base64.indexOf(","));
            byte[] decodedBytes = Base64.decode(pureBase64, Base64.DEFAULT);
            Bitmap image = BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.length);
            String m_path = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM).getAbsolutePath();
            File file = new File(m_path+"/"+ UUID.randomUUID().toString() + ".png");
            FileOutputStream out = new FileOutputStream(file);
            image.compress(Bitmap.CompressFormat.PNG, 100, out);

        } catch (Exception e) {
        }

    }

    @ReactMethod
    public void saveFileToGallery(String from){
        try {
            File f = new File(resolvePath(from));
            FileInputStream fin = new FileInputStream(f);
            BufferedReader reader = new BufferedReader(new InputStreamReader(fin));
            StringBuilder sb = new StringBuilder();
            String line = null;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            reader.close();
            fin.close();
            String base64 = sb.toString();
            String pureBase64 = base64.substring(base64.indexOf(","));
            byte[] decodedBytes = Base64.decode(pureBase64, Base64.DEFAULT);
            Bitmap image = BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.length);
            String m_path = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).getAbsolutePath();
            File file = new File(m_path, UUID.randomUUID().toString() + ".png");
            if (!file.getParentFile().mkdirs()) {
                Log.e("Module", "Directory not created");
            }
            FileOutputStream out = new FileOutputStream(file);
            image.compress(Bitmap.CompressFormat.PNG, 100, out);
            out.close();

        } catch (Exception e) {
        }
    }


    @Override
    public String getName() {
        return "FileIO";
    }
}
