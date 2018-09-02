import java.util.concurrent.atomic.AtomicIntegerArray;

class GetNSetState implements State{
    private AtomicIntegerArray value;
    private byte maxval;
    private void initlization(byte[] v){
    	value = new AtomicIntegerArray(v.length);
    	for (int i = 0; i < v.length; i++)
    		value.set(i, v[i]);
    }

    GetNSetState(byte[] v){ initlization(v);maxval = 127; }

    GetNSetState(byte[] v, byte m) { initlization(v);maxval = m; }

    public int size() { return value.length(); }

    public byte[] current(){ 
    	byte[] v = new byte[size()];
    	for (int i = 0; i < size(); i++)
    		v[i] = (byte) value.get(i);
    	return v;
    }

    public boolean swap(int i, int j) {
    	int ival = value.get(i);
    	int jval = value.get(j);
		if (ival <= 0 || jval >= maxval){
		    return false;
		}
		value.set(i, ival - 1);
		value.set(j, jval + 1);
		return true;
    }
}