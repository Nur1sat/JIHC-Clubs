import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue({
    script: {
      defineModel: true,
      propsDestructure: true
    }
  })],
  server: {
    host: '0.0.0.0', // Allow access from network
    port: 5173,
    proxy: {
      '/api': {
        target: process.env.VITE_API_URL || 'http://146.103.117.133:8000',
        changeOrigin: true
      }
    },
    fs: {
      strict: false
    }
  },
  optimizeDeps: {
    include: ['three', 'vue'],
    exclude: []
  },
  build: {
    commonjsOptions: {
      include: [/three/, /node_modules/]
    },
    rollupOptions: {
      output: {
        manualChunks: undefined
      }
    }
  },
  resolve: {
    alias: {
      '@': '/src'
    }
  }
})

