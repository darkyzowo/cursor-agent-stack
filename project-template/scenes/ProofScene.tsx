'use client';

/**
 * Proof scene — milestone 1 for R3F work.
 * Deps: three @react-three/fiber @react-three/drei
 *
 * Next.js page wrapper:
 *   dynamic(() => import('@/scenes/ProofScene'), { ssr: false })
 * Parent div MUST have explicit height (e.g. h-[480px] or h-screen).
 */
import { Canvas } from '@react-three/fiber';
import { OrbitControls } from '@react-three/drei';

function ProofMesh() {
  return (
    <mesh rotation={[0.4, 0.6, 0]}>
      <boxGeometry args={[1, 1, 1]} />
      <meshStandardMaterial color="#6366f1" />
    </mesh>
  );
}

export default function ProofScene() {
  return (
    <Canvas
      className="h-full w-full"
      dpr={[1, 2]}
      camera={{ position: [3, 3, 3], fov: 50 }}
      gl={{ antialias: true, powerPreference: 'high-performance' }}
    >
      <color attach="background" args={['#0a0a0a']} />
      <ambientLight intensity={0.4} />
      <directionalLight position={[5, 5, 5]} intensity={1} />
      <ProofMesh />
      <OrbitControls makeDefault />
    </Canvas>
  );
}
