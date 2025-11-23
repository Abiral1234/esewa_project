package com.example.addtoapp
import android.content.Intent    
import android.os.Bundle
import android.widget.Button
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import io.flutter.embedding.android.FlutterActivity
import java.util.UUID
import android.widget.Toast
import android.widget.EditText
import android.widget.Switch

class MainActivity : AppCompatActivity() {
    private lateinit var etEmail: EditText
    private lateinit var etPassword: EditText
    private lateinit var btnOpenFlutter :Button
    private lateinit var switchTheme: Switch

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_main)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
        etEmail = findViewById(R.id.etEmail)
        etPassword = findViewById(R.id.etPassword)
        btnOpenFlutter=findViewById(R.id.btn_open_flutter)
        switchTheme = findViewById(R.id.switchTheme)
        switchTheme.setOnCheckedChangeListener { _, isChecked ->
    switchTheme.text = if (isChecked) "Dark Mode" else "Light Mode"
}
        btnOpenFlutter.setOnClickListener {
             val email = etEmail.text.toString().trim()
            val password = etPassword.text.toString().trim()
            if (email.isEmpty() || password.isEmpty()) {
                Toast.makeText(this, "Email and Password are required!", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }
            else{
                val uuid = UUID.randomUUID().toString()
            val theme = if (switchTheme.isChecked) "dark" else "light"
            Toast.makeText(this, "Login successful!\nUUID: $uuid", Toast.LENGTH_LONG).show()
            val prefs = getSharedPreferences("loginData", MODE_PRIVATE).edit()
            prefs.putString("uuid", uuid)
            prefs.putString("theme", theme)
            prefs.apply()
            // val intent = Intent(this, MyFlutterActivity::class.java)
            // startActivity(intent)
            // startActivity(
            //     FlutterActivity.createDefaultIntent(this)
            // )
            startActivity(Intent(this, MyFlutterActivity::class.java))
            }
            
        }
    }
}