C-----------------------------------------------------------------------
      SUBROUTINE SPFFT1(IMAX,INCW,INCG,KMAX,W,G,IDIR)
C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C
C SUBPROGRAM:  SPFFT1     PERFORM MULTIPLE FAST FOURIER TRANSFORMS
C   PRGMMR: IREDELL       ORG: W/NMC23       DATE: 96-02-20
C
C ABSTRACT: THIS SUBPROGRAM PERFORMS MULTIPLE FAST FOURIER TRANSFORMS
C           BETWEEN COMPLEX AMPLITUDES IN FOURIER SPACE AND REAL VALUES
C           IN CYCLIC PHYSICAL SPACE.
C           SUBPROGRAM SPFFT1 INITIALIZES TRIGONOMETRIC DATA EACH CALL.
C           USE SUBPROGRAM SPFFT TO SAVE TIME AND INITIALIZE ONCE.
C           THIS VERSION INVOKES THE IBM ESSL FFT.
C
C PROGRAM HISTORY LOG:
C 1998-12-18  IREDELL
C
C USAGE:    CALL SPFFT1(IMAX,INCW,INCG,KMAX,W,G,IDIR)
C
C   INPUT ARGUMENT LIST:
C     IMAX     - INTEGER NUMBER OF VALUES IN THE CYCLIC PHYSICAL SPACE
C                (SEE LIMITATIONS ON IMAX IN REMARKS BELOW.)
C     INCW     - INTEGER FIRST DIMENSION OF THE COMPLEX AMPLITUDE ARRAY
C                (INCW >= IMAX/2+1)
C     INCG     - INTEGER FIRST DIMENSION OF THE REAL VALUE ARRAY
C                (INCG >= IMAX)
C     KMAX     - INTEGER NUMBER OF TRANSFORMS TO PERFORM
C     W        - COMPLEX(INCW,KMAX) COMPLEX AMPLITUDES IF IDIR>0
C     G        - REAL(INCG,KMAX) REAL VALUES IF IDIR<0
C     IDIR     - INTEGER DIRECTION FLAG
C                IDIR>0 TO TRANSFORM FROM FOURIER TO PHYSICAL SPACE
C                IDIR<0 TO TRANSFORM FROM PHYSICAL TO FOURIER SPACE
C
C   OUTPUT ARGUMENT LIST:
C     W        - COMPLEX(INCW,KMAX) COMPLEX AMPLITUDES IF IDIR<0
C     G        - REAL(INCG,KMAX) REAL VALUES IF IDIR>0
C
C SUBPROGRAMS CALLED:
C   SCRFT        IBM ESSL COMPLEX TO REAL FOURIER TRANSFORM
C   SRCFT        IBM ESSL REAL TO COMPLEX FOURIER TRANSFORM
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 90
C
C REMARKS:
C   THE RESTRICTIONS ON IMAX ARE THAT IT MUST BE A MULTIPLE
C   OF 1 TO 25 FACTORS OF TWO, UP TO 2 FACTORS OF THREE,
C   AND UP TO 1 FACTOR OF FIVE, SEVEN AND ELEVEN.
C
C   THIS SUBPROGRAM IS THREAD-SAFE.
C
C$$$
        IMPLICIT NONE
        INTEGER,INTENT(IN):: IMAX,INCW,INCG,KMAX,IDIR
        COMPLEX,INTENT(INOUT):: W(INCW,KMAX)
        REAL,INTENT(INOUT):: G(INCG,KMAX)
        REAL:: AUX1(25000+INT(0.82*IMAX))
        REAL:: AUX2(20000+INT(0.57*IMAX))
        INTEGER:: NAUX1,NAUX2
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        NAUX1=25000+INT(0.82*IMAX)
        NAUX2=20000+INT(0.57*IMAX)
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  FOURIER TO PHYSICAL TRANSFORM.
        SELECT CASE(IDIR)
          CASE(1:)
            CALL SCRFT(1,W,INCW,G,INCG,IMAX,KMAX,-1,1.,
     &                 AUX1,NAUX1,AUX2,NAUX2,0.,0)
            CALL SCRFT(0,W,INCW,G,INCG,IMAX,KMAX,-1,1.,
     &                 AUX1,NAUX1,AUX2,NAUX2,0.,0)
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  PHYSICAL TO FOURIER TRANSFORM.
          CASE(:-1)
            CALL SRCFT(1,G,INCG,W,INCW,IMAX,KMAX,+1,1./IMAX,
     &               AUX1,NAUX1,AUX2,NAUX2,0.,0)
            CALL SRCFT(0,G,INCG,W,INCW,IMAX,KMAX,+1,1./IMAX,
     &               AUX1,NAUX1,AUX2,NAUX2,0.,0)
        END SELECT
      END SUBROUTINE
