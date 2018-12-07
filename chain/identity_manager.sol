pragma solidity >=0.4.22 <0.6.0;

contract IdentityManager {
    uint totalOfIdentitiesEverCreated;
    mapping (address => bytes32) addressToIdentity;
    mapping (bytes32 => bytes32) identityToSecretBackupToken;

    event GotNewRandomID(bytes32 indexed randomID, bytes32 identity);
    event NewIdentityCreated(bytes32 indexed identity, address indexed member);
    event MemberStateChanged(bytes32 indexed identity, address indexed member, bool isMember);
    event SecretAdded(bytes32 indexed identity, bytes32 secret);
    event SecretConsumed(bytes32 indexed identity, bytes32 secret);
    
    function submitRandomID(bytes32 randomID) public {
        if (addressToIdentity[msg.sender] == 0x0) {
            // Create identity
            bytes32 newIdentity = keccak256(
                abi.encodePacked(
                    totalOfIdentitiesEverCreated++
                )
            );
            addressToIdentity[msg.sender] = newIdentity;

            emit NewIdentityCreated(newIdentity, msg.sender);
        }
        
        // Verify identity
        emit GotNewRandomID(randomID, addressToIdentity[msg.sender]);
    }
    
    function changeMemberState(address member, bool isMember) public {
        bytes32 identity = addressToIdentity[msg.sender];
        
        if (!isMember) {
            // We want to remove it
            require(addressToIdentity[member] == identity, "Member's identity doesn't match ours");
            
            addressToIdentity[member] = 0x0;
        } else {
            // We want to add it
            require(addressToIdentity[member] == 0x0, "Member already has an identity");
            
            addressToIdentity[member] = identity;
        }
        
        emit MemberStateChanged(identity, member, isMember);
    }
    
    // Recovery
    
    function changeRecoverySecret(bytes32 secret) public {
        bytes32 identity = addressToIdentity[msg.sender];
        require(identity != 0x0, "You have no identity, create one");
        
        identityToSecretBackupToken[identity] = secret;
        
        emit SecretAdded(identity, secret);
    }
    
    function triggerRecoveryTrap(bytes32 revealedSecret, address newMember) public {
        bytes32 identity = addressToIdentity[msg.sender];
        require(identity != 0x0, "You have no identity, create one");
        
        require(
            identityToSecretBackupToken[identity] == keccak256(
                abi.encodePacked(
                    identity,
                    revealedSecret
                )
            ),
            "Secret mismatch"
        );
        
        changeMemberState(newMember, true);
        
        emit SecretConsumed(identity, identityToSecretBackupToken[identity]);
        identityToSecretBackupToken[identity] = 0x0;
    }
}
