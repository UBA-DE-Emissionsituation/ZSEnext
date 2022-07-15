import NavigationTree from './components/NavigationTree.js'
import Statistics from './components/Statistics.js'

export default function App() {
  return (
    <div>
      <div>
        <h1>NEXTgen ZSE</h1>
      </div>
      <div>
        <h2>Navigation</h2>
        <NavigationTree />
      </div>
      <div>
        <h2>Statistics</h2>
        <Statistics />
      </div>
    </div>
  );
}